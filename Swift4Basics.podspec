
Pod::Spec.new do |s|

  s.name         = "Swift4Basics"
  s.version      = "1.0.1"
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


s.source_files  = "Swift4Basics","Swift4Basics/*.{h,m}", "Swift4Basics/**/*.{h,m}"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.preserve_paths = "CommonCrypto" , "CommonCrypto/**/*"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #



  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.requires_arc = true

 s.pod_target_xcconfig = {
 'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]' => '$(PODS_ROOT)/Swift4Basics/CommonCrypto/iphoneos',
 'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]' => '$(PODS_ROOT)/Swift4Basics/CommonCrypto/iphonesimulator'
 }

s.dependency 'SwiftyJSON' #,'>=4.0.0'
s.dependency 'KeychainSwift' #,'>=10.0.0'
s.dependency 'ObjectMapper' #,'>= 3.1.0'
s.dependency 'RealmSwift' #, '>=3.3.0'
s.dependency 'Realm' #, '>=3.3.0'
s.dependency 'Alamofire' #,'>=4.7.0'
s.dependency 'AlamofireObjectMapper'   #, '>= 5.0.0'
s.dependency 'Kingfisher' #, '>= 4.0'
s.dependency 'ReachabilitySwift' #,'>= 4.0.0'

end
