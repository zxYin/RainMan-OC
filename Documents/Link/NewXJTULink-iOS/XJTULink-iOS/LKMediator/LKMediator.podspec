Pod::Spec.new do |s|
  s.name         = "LKMediator"
  s.version      = "1.0.0"
  s.summary      = "西交Link的Mediator"

  s.description  = <<-DESC
  每建立一个模块都需要维护这个模块中的Category
                   DESC

  s.homepage     = "http://git.oschina.net/xjtulink/XJTULink-iOS"
  s.license      = "MIT"
  s.author             = { "Yunpeng Li" => "ypli.chn@outlook.com" }
  s.source       = { :git => "https://git.oschina.net/xjtulink/XJTULink-iOS.git", :tag => "#{s.version}" }

  s.source_files  = '**/*.{h,m}'
  s.resources = "**/*.{xib, storyboard, html, gif, pem, p12, plist, jpg, png, xcassets}"
  s.ios.exclude_files = '**Tests/*',"**/info.plist"
  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  
end
