#
# Be sure to run `pod lib lint DarkStarEnjoyCameraKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DarkStarEnjoyCameraKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DarkStarEnjoyCameraKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhuyuhui434@gmail.com/DarkStarEnjoyCameraKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuyuhui434@gmail.com' => 'zhuyuhui@odianyun.com' }
  s.source           = { :git => 'https://github.com/zhuyuhui434@gmail.com/DarkStarEnjoyCameraKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DarkStarEnjoyCameraKit/Classes/**/*'
  
  s.resource_bundles = {
      'DarkStarEnjoyCameraKit' => ['DarkStarEnjoyCameraKit/Assets/*'],
      'DarkStarEnjoyCameraKitExt' => [
         'DarkStarEnjoyCameraKit/AssetsExt/*',
#         'DarkStarEnjoyCameraKit/Modules/CameraSetting/View/*.xib'
       ],
      
    }

   # s.public_header_files = 'Pod/Classes/**/*.h'
   # s.frameworks = 'UIKit', 'MapKit'
   # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'DarkStarBaseKit'
  s.dependency 'DarkStarGeneralTools'
  s.dependency 'GPUImage'
  s.dependency 'Masonry'
  s.dependency 'YYModel'
  s.dependency 'YYCache'
  s.dependency 'CTMediator'
  s.dependency 'SDWebImage'
  s.dependency 'TOCropViewController'
  s.dependency 'ReactiveObjC'
  s.dependency 'DGActivityIndicatorView'
  s.dependency 'TZImagePickerController'
  # U-Share SDK UI模块
#  s.dependency 'UMengUShare/UI'
#  s.dependency 'UMengUShare/Social/WeChat'
#  s.dependency 'UMengUShare/Social/QQ'
end
