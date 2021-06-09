
Pod::Spec.new do |s|
  s.name             = 'MGPlayerViewFramework'
  s.version          = '0.2.0'
  s.summary          = 'A short description of MGPlayerView.'

  s.description      = <<-DESC
  简易视频播放器
                       DESC

  s.homepage         = 'https://github.com/mal666666/MGPlayerView'
  s.author           = { '小马哥' => 'mal666666@163.com' }
  s.source           = { :git => 'https://github.com/mal666666/MGPlayerView.git', :tag => s.version.to_s }
  
#  s.resource_bundles = {
#    'MGPlayerView' => ['MGPlayerView.bundle']
#  }
  
  s.ios.deployment_target = '9.0'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.vendored_frameworks = 'MGPlayerView.framework'
  s.dependency 'Masonry'
  s.prefix_header_contents = '#import"Masonry.h"'
  
end
