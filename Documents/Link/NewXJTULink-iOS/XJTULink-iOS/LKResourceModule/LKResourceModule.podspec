Pod::Spec.new do |s|
  s.name         = "LKResourceModule"
  s.version      = "1.0.0"
  s.summary      = "西交Link的资源模块"

  s.description  = <<-DESC
 所有的文件资源统一放在这个模块内
                   DESC

  s.homepage     = "http://git.oschina.net/xjtulink/XJTULink-iOS"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Yunpeng Li" => "ypli.chn@outlook.com" }
  s.source       = { :git => "https://git.oschina.net/xjtulink/XJTULink-iOS.git", :tag => "#{s.version}" }

  s.resources = "**/*.{html,gif,pem,p12,plist,jpg,png,xcassets}"
#  s.resources = "Resources/*", "Resources/**/*"
end
