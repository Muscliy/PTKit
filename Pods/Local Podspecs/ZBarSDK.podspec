Pod::Spec.new do |s|
  s.name     = 'ZBarSDK'
  s.version  = '1.1'
  s.license      = { :type => 'BSD / Apache License, Version 2.0', :file => 'LICENCE' }
  s.summary  = 'A Very High Performance Objective-C JSON Library.'
  s.homepage = 'http://zbar.sourceforge.net/'
  s.author   = 'John Engelhart'
  s.source   = { :svn => 'svn://202.91.251.204/cici/trunk/ios-cocoapods/ZBar', :tag => "1.1", :commit => "35360aeb577f58a49cdf4ce58dbf286e2fab39e0" }

  s.public_header_files = ["iphone/**/**/*.h",
    					  "include/*.h"]

  s.source_files   = ["include/zbar.h",
    				 "zbar/**/*.h",
    				 "iphone/*.h",
    				 "iphone/include/**/*.h",
    				 "zbar/{config,decoder,error,image,img_scanner,refcnt,scanner,symbol}.c",
    				 "zbar/decoder/{codabar,code39,code93,code128,databar,ean,i25,qr_finder}.c",
    				 "zbar/qrcode/*.c",
    				 "iphone/*.m"]
  s.resources = "iphone/res/{zbar-*.png,zbar-help.html}"
  s.frameworks =  ["AVFoundation",
    			  "CoreGraphics",
    			  "CoreMedia",
    			  "CoreVideo",
    			  "QuartzCore"]

  s.libraries = "iconv"

  s.prefix_header_file = "iphone/include/prefix.pch"
  s.compiler_flags = "-w"
  s.requires_arc = false

  s.xcconfig = {
    "EXCLUDED_SOURCE_FILE_NAMES[sdk=iphoneos*][arch=*]" => "ZBarReaderViewImpl_Simulator.m",
    "EXCLUDED_SOURCE_FILE_NAMES[sdk=iphonesimulator*][arch=*]" => "ZBarReaderViewImpl_Capture.m ZBarCaptureReader.m",
    "GCC_PREPROCESSOR_DEFINITIONS" => "NDEBUG=1"
  }
end