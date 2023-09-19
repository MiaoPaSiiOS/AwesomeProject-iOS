#
# Be sure to run `pod lib lint DarkStarUIComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DarkStarUIComponents'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DarkStarUIComponents.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhuyuhui434@gmail.com/DarkStarUIComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuyuhui434@gmail.com' => 'zhuyuhui@odianyun.com' }
  s.source           = { :git => 'https://github.com/zhuyuhui434@gmail.com/DarkStarUIComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  # s.source_files = 'DarkStarUIComponents/Classes/**/*'
  s.source_files = 'DarkStarUIComponents/Classes/DarkStarUIComponents.h'
  s.public_header_files = 'DarkStarUIComponents/Classes/DarkStarUIComponents.h'
#   s.resource_bundles = {
#     'DarkStarUIComponents' => ['DarkStarUIComponents/Assets/*']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

    #资源文件
#  s.subspec 'NrSRSTextFieldAssets' do |ss|
#    ss.resource_bundles = {'NrSRSTextFieldAssets' => ['NrUIComponents/Assets/*.*']}
#    ss.pod_target_xcconfig = {
#      'EXPANDED_CODE_SIGN_IDENTITY' => '',
#      'CODE_SIGNING_REQUIRED' => 'NO',
#      'CODE_SIGNING_ALLOWED' => 'NO',
#    }
#  end
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
#  s.subspec 'PCWaitview' do |ss|
#    ss.source_files = 'DarkStarUIComponents/Classes/PCWaitview'
#    ss.dependency 'DarkStarResourceKit'
#    ss.dependency 'DarkStarBaseKit'
#  end
#  s.subspec 'PlaceholderView' do |ss|
#    ss.source_files = 'DarkStarUIComponents/Classes/PlaceholderView'
#    ss.dependency 'Masonry'
#    ss.dependency 'DarkStarBaseKit'
#    ss.dependency 'DarkStarResourceKit'
#  end
#  s.subspec 'RectCornerView' do |ss|
#    ss.source_files = 'DarkStarUIComponents/Classes/RectCornerView'
#    ss.dependency 'Masonry'
#    ss.dependency 'DarkStarBaseKit'
#  end
#  s.subspec 'Toast' do |ss|
#    ss.source_files = 'DarkStarUIComponents/Classes/Toast'
#    ss.dependency 'Masonry'
#    ss.dependency 'MBProgressHUD'
#    ss.dependency 'DarkStarBaseKit'
#  end
  s.subspec 'ActionSheet' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/ActionSheet'
    ss.dependency 'Masonry'
    ss.dependency 'DarkStarBaseKit'
  end
  s.subspec 'AlertController' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/AlertController'
    ss.dependency 'Masonry'
    ss.dependency 'DarkStarBaseKit'
    ss.dependency 'TTTAttributedLabel'
  end
  s.subspec 'CardSwitch' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/CardSwitch'
    ss.dependency 'Masonry'
  end
  s.subspec 'CircleView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/CircleView'
    ss.dependency 'DarkStarQMUI/QMUIAnimation'
  end
  s.subspec 'CollectionViewLayout' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/CollectionViewLayout'
  end
  s.subspec 'DialogBase' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/DialogBase'
    ss.dependency 'DarkStarBaseKit'
    ss.dependency 'Masonry'
  end
  s.subspec 'DialogDate' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/DialogDate'
    ss.dependency 'DarkStarUIComponents/DialogBase'
  end
  s.subspec 'DialogMultiChoice' do |ss|
    ss.resource_bundles = {'NrDialogMultiChoiceAssets' => ['DarkStarUIComponents/Classes/DialogMultiChoice/Assets/*.*']}
    ss.source_files = 'DarkStarUIComponents/Classes/DialogMultiChoice'
    ss.dependency 'DarkStarUIComponents/DialogBase'
  end
  s.subspec 'DialogSingleChoice' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/DialogSingleChoice'
    ss.dependency 'DarkStarUIComponents/DialogBase'
  end
  s.subspec 'DownSheetView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/DownSheetView'
    ss.dependency 'Masonry'
    ss.dependency 'DarkStarBaseKit'
  end
  s.subspec 'EdgeInsetsLabel' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/EdgeInsetsLabel'
    ss.dependency 'DarkStarBaseKit'
  end
  s.subspec 'Float' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/Float'
    ss.resource_bundles = {'NrFloatAssets' => ['DarkStarUIComponents/Classes/Float/Assets/*.*']}
    ss.dependency 'DarkStarBaseKit'
    ss.dependency 'DarkStarUIComponents/ScrollView'
    ss.dependency 'Masonry'
  end
  s.subspec 'FloatingView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/FloatingView'
    ss.dependency 'DarkStarBaseKit'
  end
  s.subspec 'GestureView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/GestureView'
  end
  s.subspec 'GridView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/GridView'
    ss.dependency 'Masonry'
  end
  s.subspec 'iCarouselLoopView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/iCarouselLoopView'
    ss.dependency 'DarkStarBaseKit'
    ss.dependency 'Masonry'
    ss.dependency 'iCarousel'
    ss.dependency 'SDWebImage'
  end
  s.subspec 'NrButton' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/NrButton'
    ss.dependency 'DarkStarBaseKit'
  end
  s.subspec 'RotateView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/RotateView'
  end
  s.subspec 'ScrollView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/ScrollView'
    ss.dependency 'Masonry'
  end
  s.subspec 'SMSwipeView' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/SMSwipeView'
    ss.dependency 'DarkStarBaseKit'
  end
  s.subspec 'SRSTextField' do |ss|
    ss.source_files = 'DarkStarUIComponents/Classes/SRSTextField'
    ss.resource_bundles = {'NrSRSTextFieldAssets' => ['DarkStarUIComponents/Classes/SRSTextField/Assets/*.*']}
    ss.dependency 'DarkStarBaseKit'
    ss.dependency 'Masonry'
  end


end
