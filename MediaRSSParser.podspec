Pod::Spec.new do |s|
  s.name         = "MediaRSSParser"
  s.version      = "3.0"
  s.summary      = "Media RSS parser, built on AFNetworking 2.0."

  s.author       = { "Joshua Greene" => "jrg.developer@gmail.com" }
  s.homepage     = "https://github.com/JRG-Developer/MediaRSSParser.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/JRG-Developer/MediaRSSParser.git", :tag => "#{s.version}" }
  s.source_files = 'MediaRSSParser/*.{h,m}'

  s.dependency 'AFNetworking', '~> 2.0'
end
