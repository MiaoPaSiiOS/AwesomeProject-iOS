#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${FRAMEWORKS_FOLDER_PATH+x} ]; then
  # If FRAMEWORKS_FOLDER_PATH is not set, then there's nowhere for us to copy
  # frameworks to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

COCOAPODS_PARALLEL_CODE_SIGN="${COCOAPODS_PARALLEL_CODE_SIGN:-false}"
SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"
BCSYMBOLMAP_DIR="BCSymbolMaps"


# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

# Copies and strips a vendored framework
install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  elif [ -r "${BUILT_PRODUCTS_DIR}/$(basename "$1")" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  elif [ -r "$1" ]; then
    local source="$1"
  fi

  local destination="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
    echo "Symlinked..."
    source="$(readlink "${source}")"
  fi

  if [ -d "${source}/${BCSYMBOLMAP_DIR}" ]; then
    # Locate and install any .bcsymbolmaps if present, and remove them from the .framework before the framework is copied
    find "${source}/${BCSYMBOLMAP_DIR}" -name "*.bcsymbolmap"|while read f; do
      echo "Installing $f"
      install_bcsymbolmap "$f" "$destination"
      rm "$f"
    done
    rmdir "${source}/${BCSYMBOLMAP_DIR}"
  fi

  # Use filter instead of exclude so missing patterns don't throw errors.
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  local basename
  basename="$(basename -s .framework "$1")"
  binary="${destination}/${basename}.framework/${basename}"

  if ! [ -r "$binary" ]; then
    binary="${destination}/${basename}"
  elif [ -L "${binary}" ]; then
    echo "Destination binary is symlinked..."
    dirname="$(dirname "${binary}")"
    binary="${dirname}/$(readlink "${binary}")"
  fi

  # Strip invalid architectures so "fat" simulator / device frameworks work on device
  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries. No longer necessary as of Xcode 7.
  if [ "${XCODE_VERSION_MAJOR}" -lt 7 ]; then
    local swift_runtime_libs
    swift_runtime_libs=$(xcrun otool -LX "$binary" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u)
    for lib in $swift_runtime_libs; do
      echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
      rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
      code_sign_if_enabled "${destination}/${lib}"
    done
  fi
}
# Copies and strips a vendored dSYM
install_dsym() {
  local source="$1"
  warn_missing_arch=${2:-true}
  if [ -r "$source" ]; then
    # Copy the dSYM into the targets temp dir.
    echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${DERIVED_FILES_DIR}\""
    rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${DERIVED_FILES_DIR}"

    local basename
    basename="$(basename -s .dSYM "$source")"
    binary_name="$(ls "$source/Contents/Resources/DWARF")"
    binary="${DERIVED_FILES_DIR}/${basename}.dSYM/Contents/Resources/DWARF/${binary_name}"

    # Strip invalid architectures from the dSYM.
    if [[ "$(file "$binary")" == *"Mach-O "*"dSYM companion"* ]]; then
      strip_invalid_archs "$binary" "$warn_missing_arch"
    fi
    if [[ $STRIP_BINARY_RETVAL == 0 ]]; then
      # Move the stripped file into its final destination.
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${DERIVED_FILES_DIR}/${basename}.framework.dSYM\" \"${DWARF_DSYM_FOLDER_PATH}\""
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${DERIVED_FILES_DIR}/${basename}.dSYM" "${DWARF_DSYM_FOLDER_PATH}"
    else
      # The dSYM was not stripped at all, in this case touch a fake folder so the input/output paths from Xcode do not reexecute this script because the file is missing.
      mkdir -p "${DWARF_DSYM_FOLDER_PATH}"
      touch "${DWARF_DSYM_FOLDER_PATH}/${basename}.dSYM"
    fi
  fi
}

# Used as a return value for each invocation of `strip_invalid_archs` function.
STRIP_BINARY_RETVAL=0

# Strip invalid architectures
strip_invalid_archs() {
  binary="$1"
  warn_missing_arch=${2:-true}
  # Get architectures for current target binary
  binary_archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | awk '{$1=$1;print}' | rev)"
  # Intersect them with the architectures we are building for
  intersected_archs="$(echo ${ARCHS[@]} ${binary_archs[@]} | tr ' ' '\n' | sort | uniq -d)"
  # If there are no archs supported by this binary then warn the user
  if [[ -z "$intersected_archs" ]]; then
    if [[ "$warn_missing_arch" == "true" ]]; then
      echo "warning: [CP] Vendored binary '$binary' contains architectures ($binary_archs) none of which match the current build architectures ($ARCHS)."
    fi
    STRIP_BINARY_RETVAL=1
    return
  fi
  stripped=""
  for arch in $binary_archs; do
    if ! [[ "${ARCHS}" == *"$arch"* ]]; then
      # Strip non-valid architectures in-place
      lipo -remove "$arch" -output "$binary" "$binary"
      stripped="$stripped $arch"
    fi
  done
  if [[ "$stripped" ]]; then
    echo "Stripped $binary of architectures:$stripped"
  fi
  STRIP_BINARY_RETVAL=0
}

# Copies the bcsymbolmap files of a vendored framework
install_bcsymbolmap() {
    local bcsymbolmap_path="$1"
    local destination="${BUILT_PRODUCTS_DIR}"
    echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${bcsymbolmap_path}" "${destination}""
    rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${bcsymbolmap_path}" "${destination}"
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY:-}" -a "${CODE_SIGNING_REQUIRED:-}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identity
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    local code_sign_cmd="/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS:-} --preserve-metadata=identifier,entitlements '$1'"

    if [ "${COCOAPODS_PARALLEL_CODE_SIGN}" == "true" ]; then
      code_sign_cmd="$code_sign_cmd &"
    fi
    echo "$code_sign_cmd"
    eval "$code_sign_cmd"
  fi
}

if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "${BUILT_PRODUCTS_DIR}/AFNetworking/AFNetworking.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/CTMediator/CTMediator.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAccountKit/DarkStarAccountKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAudioRecorderKit/DarkStarAudioRecorderKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAuthorityKit/DarkStarAuthorityKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAwesomeKit/DarkStarAwesomeKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarBaseKit/DarkStarBaseKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarConfiguration/DarkStarConfiguration.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarCrypto/DarkStarCrypto.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarDataStoreKit/DarkStarDataStoreKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarDownloadManagerKit/DarkStarDownloadManagerKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarFeedKit/DarkStarFeedKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarGeneralTools/DarkStarGeneralTools.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarGrayViewKit/DarkStarGrayViewKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarKeepAliveManager/DarkStarKeepAliveManager.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarNetWorkKit/DarkStarNetWorkKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarPhotoBrowserKit/DarkStarPhotoBrowserKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarQMUI/DarkStarQMUI.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarResourceKit/DarkStarResourceKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarScanKit/DarkStarScanKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarThirdPartyKit/DarkStarThirdPartyKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarUIComponents/DarkStarUIComponents.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarUIKit/DarkStarUIKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarUpdateSDK/DarkStarUpdateSDK.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarWebKit/DarkStarWebKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DoraemonKit/DoraemonKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/FDFullscreenPopGesture/FDFullscreenPopGesture.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/FMDB/FMDB.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/GCDWebServer/GCDWebServer.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/JXCategoryView/JXCategoryView.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/MBProgressHUD/MBProgressHUD.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/MJExtension/MJExtension.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/MJRefresh/MJRefresh.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/Masonry/Masonry.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/NrLottieBridge/NrLottieBridge.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/RealReachability/RealReachability.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/RegExCategories/RegExCategories.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SDWebImage/SDWebImage.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SDWebImageWebPCoder/SDWebImageWebPCoder.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SIAlertView/SIAlertView.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SSZipArchive/SSZipArchive.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SnapKit-framework/SnapKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/TTTAttributedLabel/TTTAttributedLabel.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/YYCache/YYCache.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/YYModel/YYModel.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/YYText/YYText.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/iCarousel/iCarousel.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/libwebp/libwebp.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/lottie-ios-framework/Lottie.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/pop/pop.framework"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework "${BUILT_PRODUCTS_DIR}/AFNetworking/AFNetworking.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/CTMediator/CTMediator.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAccountKit/DarkStarAccountKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAudioRecorderKit/DarkStarAudioRecorderKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAuthorityKit/DarkStarAuthorityKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarAwesomeKit/DarkStarAwesomeKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarBaseKit/DarkStarBaseKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarConfiguration/DarkStarConfiguration.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarCrypto/DarkStarCrypto.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarDataStoreKit/DarkStarDataStoreKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarDownloadManagerKit/DarkStarDownloadManagerKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarFeedKit/DarkStarFeedKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarGeneralTools/DarkStarGeneralTools.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarGrayViewKit/DarkStarGrayViewKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarKeepAliveManager/DarkStarKeepAliveManager.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarNetWorkKit/DarkStarNetWorkKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarPhotoBrowserKit/DarkStarPhotoBrowserKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarQMUI/DarkStarQMUI.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarResourceKit/DarkStarResourceKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarScanKit/DarkStarScanKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarThirdPartyKit/DarkStarThirdPartyKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarUIComponents/DarkStarUIComponents.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarUIKit/DarkStarUIKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarUpdateSDK/DarkStarUpdateSDK.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DarkStarWebKit/DarkStarWebKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/DoraemonKit/DoraemonKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/FDFullscreenPopGesture/FDFullscreenPopGesture.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/FMDB/FMDB.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/GCDWebServer/GCDWebServer.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/JXCategoryView/JXCategoryView.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/MBProgressHUD/MBProgressHUD.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/MJExtension/MJExtension.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/MJRefresh/MJRefresh.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/Masonry/Masonry.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/NrLottieBridge/NrLottieBridge.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/RealReachability/RealReachability.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/RegExCategories/RegExCategories.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SDWebImage/SDWebImage.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SDWebImageWebPCoder/SDWebImageWebPCoder.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SIAlertView/SIAlertView.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SSZipArchive/SSZipArchive.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/SnapKit-framework/SnapKit.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/TTTAttributedLabel/TTTAttributedLabel.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/YYCache/YYCache.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/YYModel/YYModel.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/YYText/YYText.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/iCarousel/iCarousel.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/libwebp/libwebp.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/lottie-ios-framework/Lottie.framework"
  install_framework "${BUILT_PRODUCTS_DIR}/pop/pop.framework"
fi
if [ "${COCOAPODS_PARALLEL_CODE_SIGN}" == "true" ]; then
  wait
fi