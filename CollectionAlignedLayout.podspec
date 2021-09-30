#
# Be sure to run `pod lib lint CollectionAlignedLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CollectionAlignedLayout'
  s.version          = '0.2.0'
  s.summary          = 'Custom layout support left, center, right alignment and decoration view.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Custom layout support UICollectionViewCell left, center, right alignment.
And support add decoration view quickly.
                       DESC

  s.homepage         = 'https://github.com/codwam/CollectionAlignedLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'codwam' => 'codwam@gmail.com' }
  s.source           = { :git => 'https://github.com/codwam/CollectionAlignedLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CollectionAlignedLayout/Classes/**/*'

  # s.resource_bundles = {
  #   'CollectionAlignedLayout' => ['CollectionAlignedLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
