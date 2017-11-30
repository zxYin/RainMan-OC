Pod::Spec.new do |s|
  s.name         = "LKBaseModule"
  s.version      = "1.0.0"
  s.summary      = "西交Link的基础模块"

  s.description  = <<-DESC
  向此模块添加功能之前，必须考虑该功能是否真的处于基础模块。
                   DESC

  s.homepage     = "http://git.oschina.net/xjtulink/XJTULink-iOS"
  s.license      = "MIT"
  s.author             = { "Yunpeng Li" => "ypli.chn@outlook.com" }
  s.source       = { :git => "https://git.oschina.net/xjtulink/XJTULink-iOS.git", :tag => "#{s.version}" }

  # s.source_files  = '**/*.{h, m}'
  # s.resources = "**/*.{xib, storyboard, html, gif, pem, p12, plist, jpg, png, xcassets}"
  # s.ios.exclude_files = '**Tests/*',"**/info.plist"

  s.source_files  = '**/*.{h,m,c}'
  s.resources = "**/*.xib","**/*.plist","**/*.bundle"
  s.ios.exclude_files = '*Tests/*',"**/info.plist"


  s.requires_arc = true
  s.ios.deployment_target = "9.0"

end
