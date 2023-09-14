#
# Be sure to run `pod lib lint DarkStarQMUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DarkStarQMUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DarkStarQMUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhuyuhui434@gmail.com/DarkStarQMUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuyuhui434@gmail.com' => 'zhuyuhui@odianyun.com' }
  s.source           = { :git => 'https://github.com/zhuyuhui434@gmail.com/DarkStarQMUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DarkStarQMUI/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DarkStarQMUI' => ['DarkStarQMUI/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.subspec 'QMUIAnimation' do |ss|
    ss.source_files = 'DarkStarQMUI/Classes/QMUIAnimation'
  end
  s.subspec 'QMUIWeakObjectContainer' do |ss|
    ss.source_files = 'DarkStarQMUI/Classes/QMUIWeakObjectContainer'
  end
  s.subspec 'UIKitExtensions' do |ss|
    ss.source_files = 'DarkStarQMUI/Classes/UIKitExtensions'
  end
  s.subspec 'QMUILab' do |ss|
    ss.source_files = 'DarkStarQMUI/Classes/QMUILab'
    ss.dependency 'DarkStarQMUI/UIKitExtensions'
    ss.dependency 'DarkStarQMUI/QMUIWeakObjectContainer'
  end
end
