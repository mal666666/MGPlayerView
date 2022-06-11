#
# Be sure to run `pod lib lint MGPlayerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGPlayerView'
  s.version          = '0.4.4'
  s.summary          = 'A short description of MGPlayerView.'

  s.description      = <<-DESC
  简易视频播放器
                       DESC

  s.homepage         = 'https://github.com/mal666666/MGPlayerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '小马哥' => 'mal666666@163.com' }
  s.source           = { :git => 'https://github.com/mal666666/MGPlayerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.default_subspec = 'All'

  s.subspec 'All' do |ss|
    ss.dependency 'MGPlayerView/Protocol'
    ss.dependency 'MGPlayerView/Category'
    ss.dependency 'MGPlayerView/GestureView'
    ss.dependency 'MGPlayerView/ContentView'
    ss.dependency 'MGPlayerView/MaskView'
    ss.dependency 'MGPlayerView/Main'
  end

  s.subspec 'Protocol' do |ss|
    ss.source_files ='MGPlayerView/Classes/Protocol'
  end
  s.subspec 'Category' do |ss|
    ss.source_files = 'MGPlayerView/Classes/Category'
  end
  s.subspec 'ContentView' do |ss|
    ss.source_files = 'MGPlayerView/Classes/ContentView'
  end
  s.subspec 'GestureView' do |ss|
    ss.source_files = 'MGPlayerView/Classes/GestureView'
    ss.dependency 'MGPlayerView/Protocol'
  end
  s.subspec 'MaskView' do |ss|
    ss.source_files = 'MGPlayerView/Classes/MaskView'
    ss.dependency 'MGPlayerView/Category'
    ss.dependency 'MGPlayerView/GestureView'
    ss.dependency 'MGPlayerView/Protocol'
  end
  s.subspec 'Main' do |ss|
    ss.source_files = 'MGPlayerView/Classes/Main'
    ss.dependency 'MGPlayerView/GestureView'
    ss.dependency 'MGPlayerView/ContentView'
    ss.dependency 'MGPlayerView/MaskView'
  end

#  s.source_files = 'MGPlayerView/Classes/**/*'
  
  s.resource_bundles = {
    'MGPlayerView' => ['MGPlayerView/Assets/*.{xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.private_header_files = 'KissXML/Private/**/*.h'
  # s.library      = 'xml2'
  # s.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}

  # s.frameworks = 'UIKit', 'MapKit'
  # s.prefix_header_file = true
  s.dependency 'Masonry'
  s.prefix_header_contents = '#import"Masonry.h"', '#import"Common.h"'

end
