#
# Be sure to run `pod lib lint percero-ios-client.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'percero-ios-client'
  s.version          = '0.0.12'
  s.summary          = 'Percero Client Library for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Percero client library for iOS
                       DESC

  s.homepage         = 'https://github.com/plantsciences/ios-client-lib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jonnysamps' => 'jonnysamps@gmail.com' }
  s.source           = { :git => 'https://github.com/plantsciences/ios-client-lib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'percero-ios-client/Classes/**/*'
  
  # s.resource_bundles = {
  #   'percero-ios-client' => ['percero-ios-client/Assets/*.png']
  # }

  s.library   = "icucore"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'SBJson', '~> 3.1.0'
  s.dependency 'SocketRocket', '~> 0.5'
  s.dependency 'Reachability', '~> 3.2'
end