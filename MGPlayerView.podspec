#
# Be sure to run `pod lib lint MGPlayerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGPlayerView'
  s.version          = '0.1.1'
  s.summary          = 'A short description of MGPlayerView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  简易视频播放器
                       DESC

  s.homepage         = 'https://github.com/mal666666/MGPlayerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '小马哥' => 'mal666666@163.com' }
  s.source           = { :git => 'https://github.com/mal666666/MGPlayerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
#  s.default_subspec = 'All'
#
#  s.subspec 'Category' do |ss|
#    ss.source_files = 'MGPlayerView/Classes/Category/*.{h,m}'
#  end
#
#  s.subspec 'ContentView' do |ss|
#    ss.source_files = 'MGPlayerView/Classes/ContentView/*.{h,m}'
#  end
#
#  s.subspec 'All' do |ss|
#    ss.dependency 'MGPlayerView/Category'
#    ss.dependency 'MGPlayerView/ContentView'
#  end

#  s.source_files = 'MGPlayerView/Classes/**/*'
  s.source_files ='MGPlayerView/Classes/Main/*.{h,m}',
                'MGPlayerView/Classes/ContentView/*.{h,m}',
                'MGPlayerView/Classes/GestureView/*.{h,m}',
                'MGPlayerView/Classes/MaskView/*.{h,m}',
                'MGPlayerView/Classes/Category/*.{h,m}'
  
  s.resource_bundles = {
    'MGPlayerView' => ['MGPlayerView/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry'
  s.prefix_header_contents = '#import"Masonry.h"'
  
end
