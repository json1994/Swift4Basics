
Pod::Spec.new do |s|

  s.name         = "Swift4Basics"
  s.version      = "0.0.1"
  s.summary      = "Swift4.0 Basics"

  s.description  = <<-DESC
                   Swift4.0 Basics
                   DESC

  s.homepage     = "https://github.com/hw3308/Swift4Basics.git"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "hw" => "hw3308@sina.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.platform     = :ios
  s.platform     = :ios, "9.0"

  s.ios.deployment_target = "9.0"



  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.source = { :git => "https://github.com/hw3308/Swift4Basics", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


s.source_files  = "Swift4Basics","Swift4Basics/*.{h,m}", "Swift4Basics/**/*.{h,m}","Swift4Basics/**/*.swift"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.preserve_paths = "CommonCrypto" , "CommonCrypto/**/*"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #



  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.requires_arc = true

s.dependency 'SwiftyJSON'
s.dependency 'KeychainSwift'
s.dependency 'ObjectMapper'
s.dependency 'RealmSwift'
s.dependency 'Realm'
s.dependency 'Alamofire'
s.dependency 'AlamofireObjectMapper'
s.dependency 'Kingfisher'
s.dependency 'ReachabilitySwift'

end
