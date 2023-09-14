#
# Be sure to run `pod lib lint NrlottieBridge.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NrLottieBridge'
  s.version          = '0.1.1'
  s.summary          = 'A short description of NrlottieBridge.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/tuay-orn/NrLottieBridge'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhuyuhui434@gmail.com' => 'C2021900@pccc.bankcomm.com' }
  s.source           = { :git => 'https://gitee.com/tuay-orn/NrLottieBridge.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '5.0'

  s.ios.deployment_target = '10.0'

  s.source_files = 'NrLottieBridge/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NrlottieBridge' => ['NrlottieBridge/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'lottie-ios'
  s.dependency 'SnapKit'
end
#  pod repo push TuayOrn-PrivatePods NrLottieBridge.podspec --sources=https://gitee.com/tuay-orn/private-pods.git,https://github.com/CocoaPods/Specs.git --allow-warnings
