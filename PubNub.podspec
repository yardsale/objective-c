Pod::Spec.new do |s|
  s.name         = 'PubNub'
  s.version      = '3.4.1'
  s.summary      = 'Test version of PubNub client.'
  s.author = {
    'Name Soname' => 'youremail@here.com'
  }
  s.source = {
    :git => 'https://github.com/vosovets/objective-c.git',
    :tag => 'v3.4.1'
  }
  
#  s.source_files = 'Source/*.{h,m}'
  # A list of file patterns which select the source files that should be
  # added to the Pods project. If the pattern is a directory then the
  # path will automatically have '*.{h,m,mm,c,cpp}' appended.
  #
  #s.source_files = 'iOS/3.4/pubnub/libs/PubNub/Misc/PNImports.h','iOS/3.4/pubnub/libs', 'iOS/3.4/pubnub/libs/**/*.{h,m}', 'iOS/3.4/pubnub/libs/**/**/*.{h,m}', 'iOS/3.4/pubnub/libs/**/**/**/*.{h,m}'

  #s.source_files = 'iOS/3.4/pubnub'

  #s.frameworks = 'Security'
  
  
  
  s.source_files = 'iOS/3.4/pubnub/libs/PubNub/Misc/Categories',
   'iOS/3.4/pubnub/libs/PubNub/Data',
   'iOS/3.4/pubnub/libs/PubNub/Misc',
   'iOS/3.4/pubnub/libs/PubNub/Misc/Protocols',
   'iOS/3.4/pubnub/libs/PubNub/Core',
   'iOS/3.4/pubnub/libs/PubNub/Data/Channels',
   'iOS/3.4/pubnub/libs/PubNub/Data/Crypto',
   'iOS/3.4/pubnub/libs/JSONKit',
   'iOS/3.4/pubnub/libs/PubNub/Network/Packets',
   'iOS/3.4/pubnub/libs/PubNub/Data/Buffers',
   'iOS/3.4/pubnub/libs/PubNub/Network',
   'iOS/3.4/pubnub/libs/PubNub/Network/Transport',
   'iOS/3.4/pubnub/libs/PubNub/Data/Channels/Presence',
   'PNConstants.h'
  
  
#  s.compiler_flags = {'iOS/3.4/pubnub/libs/JSONKit/JSONKit.m' => '-f-no-objc-arc'}
s.compiler_flags = {'PubNub/iOS/3.4/pubnub/libs/JSONKit/JSONKit.m' => '-f-no-objc-arc'}
  s.prefix_header_file = 'iOS/3.4/pubnub/pubnub-Prefix.pch'
  s.requires_arc = true
  
s.platform = :ios

s.homepage = 'http://www.pubnub.com/'

s.license = {
    :type => 'Commercial',
    :text => <<-LICENSE
All text and design is copyright © 2010-2013  App, Inc.

All rights reserved.

https://pubnub.com
LICENSE
  }

end
