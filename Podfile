# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'


workspace 'DSDemo.xcworkspace' 

target 'DSDemo-OC' do
  project 'DSDemo-OC/DSDemo-OC.xcodeproj'

  use_frameworks!
  
  pod 'DarkStarConfiguration', :path => './CommonPods/DarkStarConfiguration/'
  pod 'DarkStarBaseKit', :path => './CommonPods/DarkStarBaseKit/'
  pod 'DarkStarUIKit', :path => './CommonPods/DarkStarUIKit/'
  pod 'DarkStarScanKit', :path => './CommonPods/DarkStarScanKit/'
  pod 'DarkStarGrayViewKit', :path => './CommonPods/DarkStarGrayViewKit/'
  pod 'DarkStarAuthorityKit', :path => './CommonPods/DarkStarAuthorityKit/'
  pod 'DarkStarGeneralTools', :path => './CommonPods/DarkStarGeneralTools/'
  pod 'DarkStarUpdateSDK', :path => './CommonPods/DarkStarUpdateSDK/'
  pod 'DarkStarCrypto', :path => './CommonPods/DarkStarCrypto/'
  pod 'DarkStarAudioRecorderKit', :path => './CommonPods/DarkStarAudioRecorderKit/'
  pod 'DarkStarThirdPartyKit', :path => './CommonPods/DarkStarThirdPartyKit/'
  pod 'DarkStarKeepAliveManager', :path => './CommonPods/DarkStarKeepAliveManager/'
  pod 'DarkStarUIComponents', :path => './CommonPods/DarkStarUIComponents/'
  pod 'DarkStarQMUI', :path => './CommonPods/DarkStarQMUI/'
  pod 'DarkStarDataStoreKit', :path => './CommonPods/DarkStarDataStoreKit/'
  pod 'DarkStarFeedKit', :path => './CommonPods/DarkStarFeedKit/'
  pod 'DarkStarNetWorkKit', :path => './CommonPods/DarkStarNetWorkKit/'
  pod 'DarkStarAccountKit', :path => './CommonPods/DarkStarAccountKit/'
  pod 'DarkStarWebKit', :path => './CommonPods/DarkStarWebKit/'
  pod 'DarkStarResourceKit', :path => './CommonPods/DarkStarResourceKit/'
  pod 'DarkStarAwesomeKit', :path => './CommonPods/DarkStarAwesomeKit/'
  pod 'DarkStarDownloadManagerKit', :path => './CommonPods/DarkStarDownloadManagerKit/'
  pod 'DarkStarPhotoBrowserKit', :path => './CommonPods/DarkStarPhotoBrowserKit/'
  pod 'DarkStarShootVideoKit', :path => './CommonPods/DarkStarShootVideoKit/'
  pod 'DarkStarEnjoyCameraKit', :path => './CommonPods/DarkStarEnjoyCameraKit/'

  
  #NrLottieBridge使用Swift版本，NrLottieMixView使用OC版本；这两个库不能同时用
  pod 'NrLottieBridge', :path => './CommonPods/NrLottieBridge/'
#  pod 'NrLottieMixView', :path => './CommonPods/NrLottieMixView/'

  
  
  # Pods for DarkStar
  pod 'AFNetworking', '~> 4.0'
  pod 'MJExtension'
  pod 'MJRefresh'
  pod 'SDWebImage'
  pod 'FMDB'
  pod 'Masonry'
  pod 'MBProgressHUD'  #弹窗
  pod 'YYCache'
  pod 'JXCategoryView'
  pod 'CTMediator'
  pod 'DoraemonKit'

end

target 'DSDemo-Swift' do
  project 'DSDemo-Swift/DSDemo-Swift.xcodeproj'

  pod 'SnapKit'
  pod 'lottie-ios'
  pod 'DateToolsSwift'
  pod 'SwiftyJSON'
  pod 'CryptoSwift'
  pod 'Kingfisher'
  pod 'TZImagePickerController'

end


# 当我们升级XCode到14.3之后，我们原先的工程，引入的一些pod库，可能就会报一些签名错误
# 在Podfile脚本中设置CODE_SIGN_IDENTITY为空来避免报错
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGN_IDENTITY'] = ''
    end
  end
end
