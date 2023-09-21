#
# Be sure to run `pod lib lint DarkStarShootVideoKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DarkStarShootVideoKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DarkStarShootVideoKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhuyuhui434@gmail.com/DarkStarShootVideoKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuyuhui434@gmail.com' => 'zhuyuhui@odianyun.com' }
  s.source           = { :git => 'https://github.com/zhuyuhui434@gmail.com/DarkStarShootVideoKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DarkStarShootVideoKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DarkStarShootVideoKit' => ['DarkStarShootVideoKit/Assets/*.png']
  # }
  s.resource_bundles = {
     'DarkStarShootVideoKit' => ['DarkStarShootVideoKit/Assets/*'],
     'DarkStarShootVideoKitExt' => ['DarkStarShootVideoKit/AssetsExt/*']
  }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'JXCategoryView'
    s.dependency 'GPUImage'
    s.dependency 'YYCache'
    s.dependency 'YYImage'
    s.dependency 'MBProgressHUD'
    s.dependency 'CTMediator'
#    s.dependency 'GPUImageCommonFilters'

    s.dependency 'DarkStarBaseKit'
    s.dependency 'DarkStarGeneralTools'
    s.dependency 'DarkStarUIKit'
    s.dependency 'DarkStarUIComponents'
end
