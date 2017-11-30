Pod::Spec.new do |s|
  s.name         = "LKClassroomModule"
  s.version      = "1.0.0"
  s.summary      = "西交Link的空闲教室"

  s.description  = <<-DESC
空闲教室相关
                   DESC

  s.homepage     = "http://git.oschina.net/xjtulink/XJTULink-iOS"
  s.license      = "MIT"
  s.author             = { "Yunpeng Li" => "ypli.chn@outlook.com" }
  s.source       = { :git => "https://git.oschina.net/xjtulink/XJTULink-iOS.git", :tag => "#{s.version}" }

  s.source_files  = '**Module/**/*.{h,m}'
  s.resources = "**Module/**/*.{xib, storyboard}", "**Module/**/*.plist"
  s.ios.exclude_files = '**Tests/*',"**/info.plist"
  s.requires_arc = true
  s.ios.deployment_target = "9.0"


  s.dependency 'LKBaseModule'
  s.dependency 'LKResourceModule'

end
