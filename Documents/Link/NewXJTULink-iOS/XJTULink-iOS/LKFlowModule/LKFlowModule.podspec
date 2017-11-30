Pod::Spec.new do |s|
  s.name         = "LKFlowModule"
  s.version      = "1.0.0"
  s.summary      = "西交Link的宿舍流量模块"

  s.description  = <<-DESC
宿舍流量相关的模块
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
