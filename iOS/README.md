# Content table
+ <a href="#about">About</a>
+ <a href="#coming-soon">Coming soon</a>
+ <a href="#installation">Installation</a>
+ <a href="#simple-example">Fast start</a>
    + <a href="#example-subscribe">Simple subscribe project</a>
    + <a href="#example-hello-world">Hello world project</a>
    + <a href="#example-blockless-event-handling">Blockless event handling project</a>
    + <a href="#example-apns">APNS support example project</a>
+ <a href="#apns-configuration">APNS setup</a>
+ <a href="#client-configuration">Client configuration</a>
+ <a href="#client-methods">Client methods</a>
+ <a href="#channel">Channel</a>
+ <a href="#client-subscription">Channel subscribe/unsubscribe</a>
+ <a href="#apns-usage">APNS support methods</a>
+ <a href="#presence">Presence</a>
+ <a href="#here-now">Here now</a>
+ <a href="#timetoken">Timetoken</a>
+ <a href="#message-publish">Publish message</a>
+ <a href="#history">History</a>
+ <a href="#error-handling">Error handling</a>
+ <a href="#event-handling">Event handling</a>
+ <a href="#logging">Logging options</a>

<a name="about"></a>
## PubNub 3.4.2 for iOS (iPhone and iPad)
Provides iOS ARC support in Objective-C for the [PubNub.com](http://www.pubnub.com/) real-time messaging network.  

All requests made by the client are asynchronous, and are handled by:

1. blocks (via calling method)
2. delegate methods
3. notifications
4. Observation Center

Detailed information on methods, constants, and notifications can be found in the corresponding header files.
## Important Changes from 3.4.0
We've added better precision for pulling history via the new PNDate types.  
If you were previously using history in 3.4.0, you will need to convert your **NSDate** parameter types to **PNDate** types, as the history methods now
take PNDate arguments, not NSDate arguments. This is as easy as replacing:

<pre>
<font color="#7243a4">NSDate</font> *startDate = [<font color="#7243a4">NSDate</font> <font color="#43277c">date</font>];  
</pre>
with  
<pre>
<font color="#547f85">PNDate</font> *startDate = [<font color="#547f85">PNDate</font> <font color="#38595d">dateWithDate</font>:[<font color="#7243a4">NSDate</font> <font color="#43277c">date</font>]]; <font color="#008123">// Convert from a date</font>
or
<font color="#547f85">PNDate</font> *startDate = [<font color="#547f85">PNDate</font> <font color="#38595d">dateWithToken</font>:[<font color="#7243a4">NSNumber</font> <font color="#43277c">numberWithInt</font>:1234567]; <font color="#008123">// Convert from a timetoken</font>
</pre>
<a name="coming-soon"></a>
## Coming Soon... CocoaPod and XCode Project Template Support!
But until then...

<a name="installation"></a>
## Adding PubNub to your project  

1. Add the PubNub library folder to your project (/libs/PubNub)  
2. Add the JSONKit support files to your project (/libs/JSONKit)

**JSONKit ARC NOTE:** PubNub core code is ARC-compliant.  We provide JSONKit only so you can run against older versions of iOS
which do not support Apples native JSON (NSJson). Since JSONKit (which is 3rd party) performs all memory management on it's own
(doesn't support ARC), we'll show you how to remove ARC warnings for it with the -fno-objc-arc setting.

3. Add PNImports to your project precompile header (.pch)  
  
   <pre><font color="#754931">#import</font> <font color="#cb3229">"PNImports.h"</font></pre>
    
4. Set the `-fno-objc-arc` compile option for JSON.m and JSONKit.m (disable ARC warnings for JSONKit)
5. Add the `CFNetwork.Framework`, `SystemConfiguration.Framework`, and `libz.dylib` link options
6. In AppDelegate.h, adopt the PNDelegate protocol:

    <pre><font color="#922b8d">@interface</font> PNAppDelegate : <font color="#7243a4">UIResponder</font> <<font color="#7243a4">UIApplicationDelegate</font>, <font color="#7243a4">PNDelegate</font>></pre>

7. In AppDelegate.m (right before the return YES line works fine)

    <pre>[<font color="#547f85">PubNub</font> <font color="#38595d">setDelegate</font>:<font color="#b7359d">self</font>]</pre>

For a more detailed walkthrough of the above steps, be sure to follow the [Hello World walkthrough doc](https://raw.github.com/pubnub/objective-c/master/iOS/HOWTO/HelloWorld/HelloWorldHOWTO_34.pdf) (more details on that in the next section...)

<a name="simple-example"></a>
## Lets start coding now with PubNub!

If you just can't wait to start using PubNub for iOS (we totally know the feeling), after performing the steps 
from [Adding PubNub to your Project](#adding-pubnub-to-your-project):

1. In your ViewController.m, add this to viewDidLoad():

    <pre><font color="#008123">// Set config and connect</font>
    [<font color="#547f85">PubNub</font> <font color="#38595d">setConfiguration</font>:[<font color="#547f85">PNConfiguration</font> <font color="#38595d">configurationForOrigin</font>:<font color="#cb3229">@"pubsub.pubnub.com"</font> 
                                                          <font color="#38595d">publishKey</font>:<font color="#cb3229">@"demo"</font> 
                                                        <font color="#38595d">subscribeKey</font>:<font color="#cb3229">@"demo"</font> 
                                                           <font color="#38595d">secretKey</font>:<font color="#cb3229">@"mySecret"</font>]];
    [<font color="#547f85">PubNub</font> <font color="#38595d">connect</font>];  
    <font color="#008123">// Define a channel</font>
    <font color="#547f85">PNChannel</font> *channel_1 = [PNChannel <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"a"</font> <font color="#38595d">shouldObservePresence</font>:<font color="#b7359d">YES</font>];
    <font color="#008123">// Subscribe on the channel</font>
    [<font color="#547f85">PubNub</font> <font color="#38595d">subscribeOnChannel</font>:channel_1];
    <font color="#008123">// Publish on the channel</font>
    [<font color="#547f85">PubNub</font> <font color="#38595d">sendMessage</font>:<font color="#cb3229">@"hello from PubNub iOS!"</font> <font color="#38595d">toChannel</font>:channel_1];</pre>
2. In your AppDelegate.m, define a didReceiveMessage delegate method:

    <pre>- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> \*)client didReceiveMessage:(<font color="#547f85">PNMessage</font> *)message {  
      <font color="#43277c">NSLog</font>([<font color="#7243a4">NSString</font> <font color="#43277c">stringWithFormat</font>:<font color="#cb3229">@"received: %@"</font>, message.<font color="#38595d">message</font>]);
   }
    </pre>


This results in a simple app that displays a PubNub 'Ping' message, published every second from PubNub PHP Bot.    

That was just a quick and dirty demo to cut your teeth on... There are five other iOS PubNub 3.4 client demo apps available! These
demonstrate in more detail how you can use the delegate and completion block features of the PubNub client for iOS.

<a name="example-subscribe"></a>
### SimpleSubscribe HOWTO

The [SimpleSubscribe](HOWTO/SimpleSubscribe/3.4) app references how to create a simple subscribe-only, non-ui application using PubNub and iOS. 
[A getting started walkthrough document is also available](https://raw.github.com/pubnub/objective-c/master/iOS/HOWTO/SimpleSubscribe/SimpleSubscribeHOWTO_34.pdf).  
This is the most basic example of how to wire it all up, and as such, should take beginners and experts alike about 5-10 minutes to complete.

<a name="example-hello-world"></a>
### Hello World HOWTO

The [Hello World](HOWTO/HelloWorld/3.4) app references how to create a simple application using PubNub and iOS. 
[A getting started walkthrough document is also available](https://raw.github.com/pubnub/objective-c/master/iOS/HOWTO/HelloWorld/HelloWorldHOWTO_34.pdf).

<a name="example-blockless-event-handling"></a>
### CallsWithoutBlocks

The [CallsWithoutBlocks](HOWTO/CallsWithoutBlocks) app references how to use PubNub more procedurally than asyncronously. If you just want to make calls, without much care
for server responses (fire and forget).

<a name="example-apns"></a>
### APNSDemo

The [APNSVideo](HOWTO/APNSVideo) app is the companion to the APNS Tutorial Videos -- keep reading for more info on this...
### Deluxe iPad Full Featured Demo

Once you are familiar with the [Hello World](HOWTO_3.4) app, The deluxe iPad-only app demonstrates all API functions in greater detail than
the Hello World app. It is intended to be a reference application.

<a name="apns-configuration"></a>
## APNS Setup

If you've enabled your keys for APNS, you can use native PubNub publish operations to send messages to iPhones and iPads via iOS push notifications!

### APNS Video Walkthrough ###

We've just added a video walkthrough, along with a sample application (based on the video) that shows from start to
end how to setup APNS with PubNub. It includes all Apple-specific setup (which appears to be the most misunderstood) as
well as the PubNub-specific setup, along with the end product app available in [HOWTO/APNSVideo](HOWTO/APNSVideo).

If after watching the video you'd like to get a more behind-the-scenes breakdown of how PubNub and APNS work together, 
refer to [APNS Development Notes](https://github.com/pubnub/objective-c/blob/master/iOS/README_FOR_APNS.md).

#### APNS Video HOWTO ####

Watch the following in order:

1. [Creating the App ID and PEM Cert File](https://vimeo.com/67419903)  
2. [Create the Provisioning Profile](https://vimeo.com/67420404)  
3. [Create and Configure PubNub Account for APNS](https://vimeo.com/67420596)  
4. [Create empty PubNub App Template](https://vimeo.com/67420599)  
5. [Configure for PNDelegate Protocol and create didReceiveMessage delegate method](https://vimeo.com/67420597)  
6. [Set keys, channel, connect, and subscribe and Test Run](https://vimeo.com/67420598)  
7. [Enable and Test for correct APNS configuration (Apple Config)](https://vimeo.com/67423576)  
8. [Provision PubNub APNS](https://vimeo.com/67423577)  

Two files referenced from the video, [generateAPNSPemKey.sh](generateAPNSPemKey.sh) and [verifyCertWithApple.sh](verifyCertWithApple.sh) are also availble 

Final product is available here: [HOWTO/APNSVideo](HOWTO/APNSVideo)

<a name="client-configuration"></a>
## Client configuration

You can test-drive the PubNub client out-of-the-box without additional configuration changes. As you get a feel for it, you can fine tune it's behaviour by tweaking the available settings.  
The client is configured via an instance of the [__PNConfiguration__](3.4/pubnub/libs/PubNub/Data/PNConfiguration.h) class. All default configuration data is stored in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h) under appropriate keys.  
Data from [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h) override any settings not explicitly set during initialisation.  

You can use few class methods to intialise and update instance properties:  

1. Retrieve reference on default client configuration (all values taken from [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  

    <pre>+ (<font color="#547f85">PNConfiguration</font> *)defaultConfiguration;</pre>
  
2. Retrieve the reference on the configuration instance via these methods:  

    <pre>+ (<font color="#547f85">PNConfiguration</font> \*)configurationWithPublishKey:(<font color="#7243a4">NSString</font> \*)publishKey
                                       subscribeKey:(<font color="#7243a4">NSString</font> \*)subscribeKey
                                          secretKey:(<font color="#7243a4">NSString</font> \*)secretKey;  
   \+ (<font color="#547f85">PNConfiguration</font> \*)configurationForOrigin:(<font color="#7243a4">NSString</font> \*)originHostName
                                    publishKey:(<font color="#7243a4">NSString</font> \*)publishKey
                                  subscribeKey:(<font color="#7243a4">NSString</font> \*)subscribeKey
                                     secretKey:(<font color="#7243a4">NSString</font> \*)secretKey;		                                 
   \+ (<font color="#547f85">PNConfiguration</font> \*)configurationForOrigin:(<font color="#7243a4">NSString</font> \*)originHostName
                                        publishKey:(<font color="#7243a4">NSString</font> \*)publishKey
                                      subscribeKey:(<font color="#7243a4">NSString</font> \*)subscribeKey
                                         secretKey:(<font color="#7243a4">NSString</font> \*)secretKey
                                         cipherKey:(<font color="#7243a4">NSString</font> \*)cipherKey;  <font color="#008123">// To initialize with encryption, use cipherKey</font></pre>

***NOTE:  When encryption is enabled, and non-encrypted messages will be passed through as the string "DECRYPTION_ERROR".**

3. Update the configuration instance using this next set of parameters:  

    1.  Timeout after which the library will report any ***non-subscription-related*** request (here now, leave, message history, message post, time token, push notification enabling) execution failure.  
    
            nonSubscriptionRequestTimeout  
            
        __Default:__ 15 seconds (_kPNNonSubscriptionRequestTimeout_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    2.  Timeout after which the library will report ***subscription-related*** request (subscribe on channel(s)) execution failure.
        The default configuration value is stored inside [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h) under __kPNSubscriptionRequestTimeout__ key.
      
            subscriptionRequestTimeout  
            
        __Default:__ 20 seconds (_kPNSubscriptionRequestTimeout_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))
    3.  Timeout after which the library will reconnect to PubNub servers (server may drop connection if there is no activity).
        The default configuration value is stored inside [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h) under __kPNConnectionIdleTimeout__ key.
      
            connectionIdleTimeout  
        __Default:__ 310 seconds (_kPNConnectionIdleTimeout_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))
        ***Please consult with PubNub support before setting this value lower than the default to avoid incurring additional charges.***  
    4.  After experiencing network connectivity loss, if network access is restored, should the client reconnect to PubNub, or stay disconnected?  
        <pre>(<font color="#922b8d">getter</font> = shouldAutoReconnectClient) autoReconnectClient</pre>
        __Default:__ YES (_kPNShouldResubscribeOnConnectionRestore_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    5.  If autoReconnectClient == YES, after experiencing network connectivity loss and subsequent reconnect, should the client resume (aka  "catchup") to where it left off before the disconnect?
        <pre>(<font color="#922b8d">getter</font> = shouldResubscribeOnConnectionRestore) resubscribeOnConnectionRestore</pre>
        __Default:__ YES (_kPNShouldResubscribeOnConnectionRestore_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    6.  Upon connection restore, should the PubNub client "catch-up" to where it left off upon reconnecting?

        <pre>(<font color="#922b8d">getter</font> = shouldRestoreSubscriptionFromLastTimeToken) restoreSubscriptionFromLastTimeToken</pre>
         __Default:__ YES (_kPNShouldRestoreSubscriptionFromLastTimeToken key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    7.  Should the PubNub client establish the connection to PubNub using SSL?
      
        <pre>(<font color="#922b8d">getter</font> = shouldUseSecureConnection) useSecureConnection</pre>
        __Default:__ YES (_kPNSecureConnectionRequired__ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    8.  When SSL is enabled, should PubNub client ignore all SSL certificate-handshake issues and still continue in SSL mode if it experiences issues handshaking across local proxies, firewalls, etc?  
        <pre>(<font color="#922b8d">getter</font> = shouldReduceSecurityLevelOnError) reduceSecurityLevelOnError</pre>
        __Default:__ YES (_kPNShouldReduceSecurityLevelOnError_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    9.  When SSL is enabled, should the client fallback to a non-SSL connection if it experiences issues handshaking across local proxies, firewalls, etc?  
        <pre>(<font color="#922b8d">getter</font> = canIgnoreSecureConnectionRequirement) ignoreSecureConnectionRequirement</pre>
        __Default:__ YES (_kPNCanIgnoreSecureConnectionRequirement_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
    10.  Whether client should receive compressed messages from PubNub servers or not?  
        <pre>(<font color="#922b8d">getter</font> = shouldAcceptCompressedResponse) acceptCompressedResponse</pre>
        __Default:__ YES (_kPNCanIgnoreSecureConnectionRequirement_ key in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h))  
  
***NOTE: If you are using the `+defaultConfiguration` method to create your configuration instance, than you will need to update:  _kPNPublishKey_, _kPNSubscriptionKey_ and _kPNOriginHost_ keys in [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h).***
  
PubNub client configuration is then set via:
  
<pre>[<font color="#547f85">PubNub</font> <font color="#38595d">setConfiguration</font>:[<font color="#547f85">PNConfiguration</font> <font color="#38595d">defaultConfiguration</font>]];</pre>
        
After this call, your PubNub client will be configured with the default values taken from [__PNDefaultConfiguration.h__](3.4/pubnub/libs/PubNub/Misc/PNDefaultConfiguration.h) and is now ready to connect to the PubNub real-time network!
  
Other methods which allow you to adjust the client configuration are:  
<pre>
+ (<font color="#b7359d">void</font>)setConfiguration:(<font color="#547f85">PNConfiguration</font> *)configuration;  
+ (<font color="#b7359d">void</font>)setupWithConfiguration:(<font color="#547f85">PNConfiguration</font> *)configuration andDelegate:(<font color="#b7359d">id</font><<font color="#547f85">PNDelegate</font>>)delegate;  
+ (<font color="#b7359d">void</font>)setDelegate:(<font color="#b7359d">id</font><<font color="#547f85">PNDelegate</font>>)delegate;  
+ (<font color="#b7359d">void</font>)setClientIdentifier:(<font color="#7243a4">NSString</font> *)identifier;  
</pre>
    
The above first two methods (which update client configuration) may require a __hard state reset__ if the client is already connected. A "__hard state reset__" is when the client closes all connections to the server and reconnects back using the new configuration (including previous channel list).

Changing the UUID mid-connection requires a "__soft state reset__".  A "__soft state reset__" is when the client sends an explicit `leave` request on any subscribed channels, and then resubscribes with its new UUID.

<a name="client-methods"></a>
## PubNub client methods  

### Client information access

Access to the PubNub client singleton instance can be done with next method:
<pre>
+ (<font color="#547f85">PubNub</font> *)sharedInstance;  
</pre>
But there is not that much situations where you will habe to use it.

During connection client represent itself to the other with `identifier` which can be set during connection and checked using next method:
<pre>
+ (<font color="#7243a4">NSString</font> *)clientIdentifier;  
</pre>
To check whether client currently connected to PubNub services or not, you can use next method
<pre>
- (<font color="#b7359d">BOOL</font>)isConnected;  
</pre>  
There is clean up method, which will completely reset client. Maybe you need to preserve some resources when your application is sent to background context. Don't forget to reinitialize client after you call this method, or you will get errors in callbacks and delegate methods.
<pre>
+ (<font color="#b7359d">void</font>)resetClient;  
</pre>  
  
  
### Connecting and Disconnecting from the PubNub Network

You can use the callback-less connection methods `+connect` to establish a connection to the remote PubNub service, or the method with state callback blocks `+connectWithSuccessBlock:errorBlock:`.  

For example, you can use the provided method in the form that best suits your needs:
<pre>
<font color="#008123">// Configure client (we will use client generated identifier)</font>
[<font color="#547f85">PubNub</font> <font color="#38595d">setConfiguration</font>:[<font color="#547f85">PNConfiguration</font> <font color="#38595d">defaultConfiguration</font>]];  
    
[<font color="#547f85">PubNub</font> <font color="#38595d">connect</font>];  
</pre>
or
<pre>
<font color="#008123">// Configure client</font>
[<font color="#547f85">PubNub</font> <font color="#38595d">setConfiguration</font>:[<font color="#547f85">PNConfiguration</font> <font color="#38595d">defaultConfiguration</font>]];
[<font color="#547f85">PubNub</font> <font color="#38595d">setClientIdentifier</font>:@"test_user"];  

[<font color="#547f85">PubNub</font> <font color="#38595d">connectWithSuccessBlock</font>:^(<font color="#7243a4">NSString</font> *origin) {

                             <font color="#008123">// Do something after client connected</font>
                         } 
                     <font color="#38595d">errorBlock</font>:^(<font color="#547f85">PNError</font> *error) {
                                              
                             <font color="#008123">// Handle error which occurred while client tried to
                             // establish connection with remote service</font>
                         }];
</pre>
                                          
Disconnecting is as simple as calling `[PubNub disconnect]`.  The client will close the connection and clean up memory.

<a name="channel"></a>
### Channels representation  

The client uses the [__PNChannel__](3.4/pubnub/libs/PubNub/Data/Channels/PNChannel.h) instance instead of string literals to identify the channel.  When you need to send a message to the channel, specify the corresponding [__PNChannel__](3.4/pubnub/libs/PubNub/Data/Channels/PNChannel.h) instance in the message sending methods.  

The [__PNChannel__](3.4/pubnub/libs/PubNub/Data/Channels/PNChannel.h) interface provides methods for channel instantiation (instance is only created if it doesn't already exist):  
<pre>
+ (<font color="#7243a4">NSArray</font> *)channelsWithNames:(<font color="#7243a4">NSArray</font> *)channelsName;  

+ (<font color="#b7359d">id</font>)channelWithName:(<font color="#7243a4">NSString</font> *)channelName;  
+ (<font color="#b7359d">id</font>)channelWithName:(<font color="#7243a4">NSString</font> *)channelName shouldObservePresence:(<font color="#b7359d">BOOL</font>)observePresence;  
</pre>

You can use the first method if you want to receive a set of [__PNChannel__](3.4/pubnub/libs/PubNub/Data/Channels/PNChannel.h) instances from the list of channel identifiers.  The `observePresence` property is used to set whether or not the client should observe presence events on the specified channel.

As for the channel name, you can use any characters you want except ',' and '/', as they are reserved.

The [__PNChannel__](3.4/pubnub/libs/PubNub/Data/Channels/PNChannel.h) instance can provide information about itself:  
    
* `name` - channel name  
* `updateTimeToken` - time token of last update on this channel  
* `presenceUpdateDate` - date when last presence update arrived to this channel  
* `participantsCount` - number of participants in this channel
* `participants` - list of participant UUIDs  
  
For example, to receive a reference on a list of channel instances:  
  
<pre><font color="#7243a4">NSArray</font> *channels = [<font color="#547f85">PNChannel</font> <font color="#38595d">channelsWithNames</font>:<font color="#3d44f8">@[</font><font color="#cb3229">@"iosdev"</font>, <font color="#cb3229">@"andoirddev"</font>, <font color="#cb3229">@"wpdev"</font>, <font color="#cb3229">@"ubuntudev"</font><font color="#3d44f8">]</font>];</pre>

<a name="client-subscription"></a>
### Subscribing and Unsubscribing from Channels

The client provides a set of methods which allow you to subscribe to channel(s):  
<pre>
+ (<font color="#7243a4">NSArray</font> *)subscribedChannels;
+ (<font color="#b7359d">BOOL</font>)isSubscribedOnChannel:(<font color="#547f85">PNChannel</font> *)channel;
+ (<font color="#b7359d">void</font>)subscribeOnChannel:(<font color="#547f85">PNChannel</font> *)channel;  
+ (<font color="#b7359d">void</font>) subscribeOnChannel:(<font color="#547f85">PNChannel</font> *)channel  
withCompletionHandlingBlock:(<font color="#547f85">PNClientChannelSubscriptionHandlerBlock</font>)handlerBlock;  

+ (<font color="#b7359d">void</font>)subscribeOnChannel:(<font color="#547f85">PNChannel</font> *)channel withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent;  
+ (<font color="#b7359d">void</font>)subscribeOnChannel:(<font color="#547f85">PNChannel</font> *)channel  
         withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent  
andCompletionHandlingBlock:(<font color="#547f85">PNClientChannelSubscriptionHandlerBlock</font>)handlerBlock;  
    
+ (<font color="#b7359d">void</font>)subscribeOnChannels:(<font color="#7243a4">NSArray</font> *)channels;  
+ (<font color="#b7359d">void</font>)subscribeOnChannels:(<font color="#7243a4">NSArray</font> *)channels  
withCompletionHandlingBlock:(<font color="#547f85">PNClientChannelSubscriptionHandlerBlock</font>)handlerBlock;  

+ (<font color="#b7359d">void</font>)subscribeOnChannels:(<font color="#7243a4">NSArray</font> *)channels withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent;  
+ (<font color="#b7359d">void</font>)subscribeOnChannels:(<font color="#7243a4">NSArray</font> *)channels  
          withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent  
 andCompletionHandlingBlock:(<font color="#547f85">PNClientChannelSubscriptionHandlerBlock</font>)handlerBlock;
</pre>

Each subscription method has designated methods, one to add a presence flag, and another to add a handling block.  If `withPresenceEvent` is set to `YES`, the client will automatically receive "Presence" ('join', 'leave', and 'timeout') events for channels as you subscribe to them.

Here are some subscribe examples:
<pre>
<font color="#008123">// Subscribe to the channel "iosdev" and because shouldObservePresence is true,
// also automatically subscribes to "iosdev-pnpres" (the Presence channel for "iosdev")</font>
[<font color="#547f85">PubNub</font> <font color="#38595d">subscribeOnChannel</font>:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font> <font color="#38595d">shouldObservePresence</font>:<font color="#b7359d">YES</font>]];  

<font color="#008123">// Subscribe on set of channels with subscription state handling block</font>
[<font color="#547f85">PubNub</font> <font color="#38595d">subscribeOnChannels</font>:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelsWithNames</font>:<font color="#3d44f8">@[</font><font color="#cb3229">@"iosdev"</font>, <font color="#cb3229">@"andoirddev"</font>, <font color="#cb3229">@"wpdev"</font>, <font color="#cb3229">@"ubuntudev"</font><font color="#3d44f8">]</font>]  
<font color="#38595d">withCompletionHandlingBlock</font>:^(<font color="#547f85">PNSubscriptionProcessState</font> state, <font color="#7243a4">NSArray</font> *channels, <font color="#547f85">PNError</font> *subscriptionError) {  

    <font color="#b7359d">switch</font>(state) {  
    
        <font color="#b7359d">case</font> <font color="#547f85">PNSubscriptionProcessNotSubscribedState</font>:  
        
            <font color="#008123">// Check whether 'subscriptionError' instance is nil or not (if not, handle error)</font>
            <font color="#b7359d">break</font>;  
        <font color="#b7359d">case</font> <font color="#547f85">PNSubscriptionProcessSubscribedState</font>:  
        
            <font color="#008123">// Do something after subscription completed</font>
            <font color="#b7359d">break</font>;  
        <font color="#b7359d">case</font> <font color="#547f85">PNSubscriptionProcessWillRestoreState</font>:  
        
            <font color="#008123">// Library is about to restore subscription on channels after connection went down and restored</font>
            <font color="#b7359d">break</font>;  
        <font color="#b7359d">case</font> <font color="#547f85">PNSubscriptionProcessRestoredState</font>:  
        
            <font color="#008123">// Handle event that client completed resubscription</font>
            <font color="#b7359d">break</font>;  
    }  
}];  
</pre>

The client of course also provides a set of methods which allow you to unsubscribe from channels:  
<pre>
+ (<font color="#b7359d">void</font>)unsubscribeFromChannel:(<font color="#547f85">PNChannel</font> *)channel;  
+ (<font color="#b7359d">void</font>)unsubscribeFromChannel:(<font color="#547f85">PNChannel</font> *)channel  
   withCompletionHandlingBlock:(<font color="#547f85">PNClientChannelUnsubscriptionHandlerBlock</font>)handlerBlock;  
   
+ (<font color="#b7359d">void</font>)unsubscribeFromChannel:(<font color="#547f85">PNChannel</font> *)channel withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent;  
+ (<font color="#b7359d">void</font>)unsubscribeFromChannel:(<font color="#547f85">PNChannel</font> *)channel  
             withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent  
    andCompletionHandlingBlock:(<font color="#547f85">PNClientChannelUnsubscriptionHandlerBlock</font>)handlerBlock;  
    
+ (<font color="#b7359d">void</font>)unsubscribeFromChannels:(<font color="#43277c">NSArray</font> *)channels;  
+ (<font color="#b7359d">void</font>)unsubscribeFromChannels:(<font color="#43277c">NSArray</font> *)channels  
    withCompletionHandlingBlock:(<font color="#547f85">PNClientChannelUnsubscriptionHandlerBlock</font>)handlerBlock;  
	    
+ (<font color="#b7359d">void</font>)unsubscribeFromChannels:(<font color="#43277c">NSArray</font> *)channels withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent;  
+ (<font color="#b7359d">void</font>)unsubscribeFromChannels:(<font color="#43277c">NSArray</font> *)channels  
              withPresenceEvent:(<font color="#b7359d">BOOL</font>)withPresenceEvent  
     andCompletionHandlingBlock:(<font color="#547f85">PNClientChannelUnsubscriptionHandlerBlock</font>)handlerBlock;  
</pre>
	     
As for the subscription methods, there are a set of methods which perform unsubscribe requests.  The `withPresenceEvent` parameter set to `YES` when unsubscribing will mean that the client will send a `leave` message to channels when unsubscribed.

Lets see how we can use some of this methods to unsubscribe from channel(s):
<pre>
<font color="#008123">// Unsubscribe from set of channels and notify everyone that we are left</font>
[<font color="#547f85">PubNub</font> <font color="#38595d">unsubscribeFromChannels</font>:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelsWithNames</font>:<font color="#3d44f8">@[</font><font color="#cb3229">@"iosdev/networking"</font>, <font color="#cb3229">@"andoirddev"</font>, <font color="#cb3229">@"wpdev"</font>, <font color="#cb3229">@"ubuntudev"</font><font color="#3d44f8">]</font>]  
              <font color="#38595d">withPresenceEvent</font>:<font color="#b7359d">YES</font>
     <font color="#38595d">andCompletionHandlingBlock</font>:^(<font color="#7243a4">NSArray</font> *channels, <font color="#547f85">PNError</font> *unsubscribeError) {  
     
        <font color="#008123">// Check whether "unsubscribeError" is nil or not (if not, than handle error)</font>
    }];
</pre>

<a name="apns-usage"></a>
### APNS support methods

PubNub 3.4.2 provide ability to send push notifications from one client to another one. To be able to receive push notifications, client should subscribe on channel on which push notifications will be sent from another client.  
There is a set of API which allow to register/unregister channel from push notifications observation:
<pre>
+ (<font color="#b7359d">void</font>)enablePushNotificationsOnChannel:(<font color="#547f85">PNChannel</font> *)channel withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken;
+ (<font color="#b7359d">void</font>)enablePushNotificationsOnChannel:(<font color="#547f85">PNChannel</font> *)channel
                     withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken
              andCompletionHandlingBlock:(<font color="#547f85">PNClientPushNotificationsEnableHandlingBlock</font>)handlerBlock;
+ (<font color="#b7359d">void</font>)enablePushNotificationsOnChannels:(<font color="#7243a4">NSArray</font> *)channels withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken;
+ (<font color="#b7359d">void</font>)enablePushNotificationsOnChannels:(<font color="#7243a4">NSArray</font> *)channels
                      withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken
               andCompletionHandlingBlock:(<font color="#547f85">PNClientPushNotificationsEnableHandlingBlock</font>)handlerBlock;

+ (<font color="#b7359d">void</font>)disablePushNotificationsOnChannel:(<font color="#547f85">PNChannel</font> *)channel withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken;
+ (<font color="#b7359d">void</font>)disablePushNotificationsOnChannel:(<font color="#547f85">PNChannel</font> *)channel
                     withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken
              andCompletionHandlingBlock:(<font color="#547f85">PNClientPushNotificationsDisableHandlingBlock</font>)handlerBlock;
+ (<font color="#b7359d">void</font>)disablePushNotificationsOnChannels:(<font color="#7243a4">NSArray</font> *)channels withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken;
+ (<font color="#b7359d">void</font>)disablePushNotificationsOnChannels:(<font color="#7243a4">NSArray</font> *)channels
                       withDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken
                andCompletionHandlingBlock:(<font color="#547f85">PNClientPushNotificationsDisableHandlingBlock</font>)handlerBlock;
</pre>

API require user to specify `NSData` instance which is device push token received from Apple Push Notification Service when application register on notifications. Here is small exmaple of how to enable push notification on single channels.
<pre>
<font color="#008123">// Add this code in your application:didFinishLaunchingWithOptions: UIApplication delegate method</font>
...
<font color="#43277c">UIRemoteNotificationType</font> types = (<font color="#43277c">UIRemoteNotificationTypeAlert</font>|<font color="#43277c">UIRemoteNotificationTypeBadge</font>);
[[<font color="#7243a4">UIApplication</font> <font color="#43277c">sharedApplication</font>] <font color="#43277c">registerForRemoteNotificationTypes</font>:types];
…

<font color="#008123">// Add few methods from UIApplication delegate protocol to handle push notification registration process</font>
- (<font color="#b7359d">void</font>)application:(<font color="#7243a4">UIApplication</font> *)application didRegisterForRemoteNotificationsWithDeviceToken:(<font color="#7243a4">NSData</font> *)deviceToken {
    
    [<font color="#547f85">PubNub</font> <font color="#38595d">enablePushNotificationsOnChannels</font>:<font color="#3d44f8">@[</font>[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font>]<font color="#3d44f8">]</font>
                          <font color="#38595d">withDevicePushToken</font>:deviceToken
                   <font color="#38595d">andCompletionHandlingBlock</font>:^(<font color="#7243a4">NSArray</font> *channels, <font color="#547f85">PNError</font> *error) {
                       
                       <font color="#b7359d">if</font> (error == <font color="#b7359d">nil</font>) {
                           
                           <font color="#008123">// Do something after channel enabled push notification</font>
                       }
                       <font color="#b7359d">else</font> {
                           
                           <font color="#008123">// Handle error</font>
                       }
                   }];
}

- (void)application:(<font color="#7243a4">UIApplication</font> *)application didFailToRegisterForRemoteNotificationsWithError:(<font color="#7243a4">NSError</font> *)error {
    
    <font color="#008123">// Handle registration failure</font>
}
</pre>

Also there is API which allow to receive list of channels on which push notification observation is enabled and remove push notification observation from all channels:
<pre>
+ (<font color="#b7359d">void</font>)removeAllPushNotificationsForDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken
                         withCompletionHandlingBlock:(<font color="#547f85">PNClientPushNotificationsRemoveHandlingBlock</font>)handlerBlock;
+ (<font color="#b7359d">void</font>)requestPushNotificationEnabledChannelsForDevicePushToken:(<font color="#7243a4">NSData</font> *)pushToken
                                     withCompletionHandlingBlock:(<font color="#547f85">PNClientPushNotificationsEnabledChannelsHandlingBlock</font>)handlerBlock;
</pre>

<a name="presence"></a>
### Presence

If you've enabled the Presence feature for your account, then the client can be used to also receive real-time updates about a particual UUID's presence events, such as join, leave, and timeout.  
To use the Presence feature in your app, the follow methods are provided:
<pre>
+ (<font color="#b7359d">BOOL</font>)isPresenceObservationEnabledForChannel:(<font color="#547f85">PNChannel</font> *)channel;  
+ (<font color="#b7359d">void</font>)enablePresenceObservationForChannel:(<font color="#547f85">PNChannel</font> *)channel;  
+ (<font color="#b7359d">void</font>)enablePresenceObservationForChannel:(<font color="#547f85">PNChannel</font> *)channel
                withCompletionHandlingBlock:(<font color="#547f85">PNClientPresenceEnableHandlingBlock</font>)handlerBlock;
+ (<font color="#b7359d">void</font>)enablePresenceObservationForChannels:(<font color="#7243a4">NSArray</font> *)channels;
+ (<font color="#b7359d">void</font>)enablePresenceObservationForChannels:(<font color="#7243a4">NSArray</font> *)channels
                 withCompletionHandlingBlock:(<font color="#547f85">PNClientPresenceEnableHandlingBlock</font>)handlerBlock;
+ (<font color="#b7359d">void</font>)disablePresenceObservationForChannel:(<font color="#547f85">PNChannel</font> *)channel; 
+ (<font color="#b7359d">void</font>)disablePresenceObservationForChannel:(<font color="#547f85">PNChannel</font> *)channel
                 withCompletionHandlingBlock:(<font color="#547f85">PNClientPresenceDisableHandlingBlock</font>)handlerBlock; 
+ (<font color="#b7359d">void</font>)disablePresenceObservationForChannels:(<font color="#7243a4">NSArray</font> *)channels;
+ (<font color="#b7359d">void</font>)disablePresenceObservationForChannels:(<font color="#7243a4">NSArray</font> *)channels
                  withCompletionHandlingBlock:(<font color="#547f85">PNClientPresenceDisableHandlingBlock</font>)handlerBlock;
</pre>

Example:  
<pre>
[<font color="#547f85">PubNub</font> <font color="#38595d">enablePresenceObservationForChannels</font>:<font color="#3d44f8">@[</font>[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font>]<font color="#3d44f8">]</font>
                 <font color="#38595d">withCompletionHandlingBlock</font>:^(<font color="#7243a4">NSArray</font> *channels, <font color="#547f85">PNError</font> *error) {
                          
                    <font color="#b7359d">if</font> (error == <font color="#b7359d">nil</font>) {  
        
                        <font color="#008123">// Handle presence enabled on speified list of channels</font>
                    }  
                    <font color="#b7359d">else</font> {  
            
                        <font color="#008123">// Handle presence enabling failed</font>
                    }  
                 }];
</pre>

<a name="here-now"></a>    
### Who is "Here Now" ?

As Presence provides a way to receive occupancy information in real-time, the ***Here Now*** feature allows you enumerate current channel occupancy information on-demand.  
Two methods are provided for this:
<pre>
+ (<font color="#b7359d">void</font>)requestParticipantsListForChannel:(<font color="#547f85">PNChannel</font> *)channel;  
+ (<font color="#b7359d">void</font>)requestParticipantsListForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                      withCompletionBlock:(<font color="#547f85">PNClientParticipantsHandlingBlock</font>)handleBlock;  
</pre>
                      
Example:  
<pre>
    [<font color="#547f85">PubNub</font> <font color="#38595d">requestParticipantsListForChannel</font>:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font>]  
                          <font color="#38595d">withCompletionBlock</font>:^(<font color="#7243a4">NSArray</font> *udids, <font color="#547f85">PNChannel</font> *channel,  <font color="#547f85">PNError</font> *error) {  
                          
        <font color="#b7359d">if</font> (error == <font color="#b7359d">nil</font>) {  
        
            <font color="#008123">// Handle participants UDIDs retrival</font>
        }  
        <font color="#b7359d">else</font> {  
            
            <font color="#008123">// Handle participants request error</font>
        }  
    }];
</pre>

<a name="timetoken"></a> 
### Timetoken

You can fetch the current PubNub timetoken by using the following methods:  
<pre>
+ (<font color="#b7359d">void</font>)requestServerTimeToken;
+ (<font color="#b7359d">void</font>)requestServerTimeTokenWithCompletionBlock:(<font color="#547f85">PNClientTimeTokenReceivingCompleteBlock</font>)success;
</pre>
    
Usage is very simple:  
<pre>
[<font color="#547f85">PubNub</font> <font color="#38595d">requestServerTimeTokenWithCompletionBlock</font>:^(<font color="#7243a4">NSNumber</font> *timeToken, <font color="#547f85">PNError</font> *error) {  
    
    <font color="#b7359d">if</font> (error == <font color="#b7359d">nil</font>) {  
    
        <font color="#008123">// Use received time token as you whish</font>
    }  
    <font color="#b7359d">else</font> {
        
        <font color="#008123">// Handle time token retrival error</font>
    }  
}];  
</pre>

<a name="message-publish"></a>
### Publishing Messages

Messages can be an instance of one of the following classed: __NSString__, __NSNumber__, __NSArray__, __NSDictionary__, or __NSNull__.  
If you use some other JSON serialization kit or do it by yourself, ensure that JSON comply with all requirements. If JSON string is mailformed you will receive corresponding error from remote server.  

You can use the following methods to send messages:  
<pre>
+ (<font color="#547f85">PNMessage</font> *)sendMessage:(<font color="#b7359d">id</font>)message toChannel:(<font color="#547f85">PNChannel</font> *)channel;   
+ (<font color="#547f85">PNMessage</font> *)sendMessage:(<font color="#b7359d">id</font>)message  
                 toChannel:(<font color="#547f85">PNChannel</font> *)channel  
       withCompletionBlock:(<font color="#547f85">PNClientMessageProcessingBlock</font>)success;  
   
+ (<font color="#b7359d">void</font>)sendMessage:(<font color="#547f85">PNMessage</font> *)message;  
+ (<font color="#b7359d">void</font>)sendMessage:(<font color="#547f85">PNMessage</font> *)message withCompletionBlock:(<font color="#547f85">PNClientMessageProcessingBlock</font>)success;  
</pre>

The first two methods return a [__PNMessage__](3.4/pubnub/libs/PubNub/Data/PNMessage.h) instance. If there is a need to re-publish this message for any reason, (for example, the publish request timed-out due to lack of Internet connection), it can be passed back to the last two methods to easily re-publish.
<pre>
    <font color="#547f85">PNMessage</font> *helloMessage = [<font color="#547f85">PubNub</font> <font color="#38595d">sendMessage</font>:<font color="#cb3229">@"Hello PubNub"</font>  
                                        <font color="#38595d">toChannel</font>:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font>]  
                              <font color="#38595d">withCompletionBlock</font>:^(<font color="#547f85">PNMessageState</font> messageSendingState, <font color="#b7359d">id</font> data) {  
                                    
                                  <font color="#b7359d">switch</font> (messageSendingState) {  
                                        
                                      <font color="#b7359d">case</font> <font color="#547f85">PNMessageSending</font>:  
                                            
                                          <font color="#008123">// Handle message sending event (it means that message processing started and  
                                          // still in progress)</font>
                                          <font color="#b7359d">break</font>;  
                                      <font color="#b7359d">case</font> <font color="#547f85">PNMessageSent</font>:  
                                          
                                          <font color="#008123">// Handle message sent event</font>
                                          <font color="#b7359d">break</font>;  
                                      <font color="#b7359d">case</font> <font color="#547f85">PNMessageSendingError</font>:  
                                          
                                          <font color="#008123">// Retry message sending (but in real world should check error and hanle it)</font>
                                          [<font color="#547f85">PubNub</font> <font color="#38595d">sendMessage</font>:helloMessage];  
                                          <font color="#b7359d">break</font>;  
                                  }  
                              }];  
</pre>
Here is examplehow to send __NSDictionary__:  
<pre>
[<font color="#547f85">PubNub</font> <font color="#38595d">sendMessage</font>:<font color="#3d44f8">@{</font><font color="#cb3229">@"message"</font>:<font color="#cb3229">@"Hello from dictionary object"</font><font color="#3d44f8">}</font> 
          toChannel:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font>];
</pre>
              

<a name="history"></a>
### History

If you have enabled the history feature for your account, the following methods can be used to fetch message history:  
<pre>
+ (<font color="#b7359d">void</font>)requestFullHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel;  
+ (<font color="#b7359d">void</font>)requestFullHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel   
                 withCompletionBlock:(<font color="#547f85">PNClientHistoryLoadHandlingBlock</font>)handleBlock;  
                     
+ (<font color="#b7359d">void</font>)requestHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel from:(<font color="#547f85">PNDate</font> *)startDate to:(<font color="#547f85">PNDate</font> *)endDate;  
+ (<font color="#b7359d">void</font>)requestHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                            from:(<font color="#547f85">PNDate</font> *)startDate  
                              to:(<font color="#547f85">PNDate</font> *)endDate  
             withCompletionBlock:(<font color="#547f85">PNClientHistoryLoadHandlingBlock</font>)handleBlock;  
                 
+ (<font color="#b7359d">void</font>)requestHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                            from:(<font color="#547f85">PNDate</font> *)startDate  
	                          to:(<font color="#547f85">PNDate</font> *)endDate  
	                       limit:(<font color="#43277c">NSUInteger</font>)limit;  
+ (<font color="#b7359d">void</font>)requestHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                            from:(<font color="#547f85">PNDate</font> *)startDate  
                              to:(<font color="#547f85">PNDate</font> *)endDate  
                           limit:(<font color="#43277c">NSUInteger</font>)limit  
             withCompletionBlock:(<font color="#547f85">PNClientHistoryLoadHandlingBlock</font>)handleBlock;  

+ (<font color="#b7359d">void</font>)requestHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                            from:(<font color="#547f85">PNDate</font> *)startDate  
                              to:(<font color="#547f85">PNDate</font> *)endDate  
                           limit:(<font color="#43277c">NSUInteger</font>)limit  
                  reverseHistory:(<font color="#b7359d">BOOL</font>)shouldReverseMessageHistory;  
+ (<font color="#b7359d">void</font>)requestHistoryForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                            from:(<font color="#547f85">PNDate</font> *)startDate  
                              to:(<font color="#547f85">PNDate</font> *)endDate  
                           limit:(<font color="#43277c">NSUInteger</font>)limit  
                  reverseHistory:(<font color="#b7359d">BOOL</font>)shouldReverseMessageHistory  
             withCompletionBlock:(<font color="#547f85">PNClientHistoryLoadHandlingBlock</font>)handleBlock;  
</pre>
	             
The first two methods will receive the full message history for a specified channel.  ***Be careful, this could be a lot of messages, and consequently, a very long process!***
  
In the following example, we pull history for the `iosdev` channel within the specified time frame, limiting the maximum number of messages returned to 34:
<pre>
    <font color="#547f85">PNDate</font> *startDate = [<font color="#547f85">PNDate</font> <font color="#38595d">dateWithDate</font>:[<font color="#7243a4">NSDate</font> <font color="#43277c">dateWithTimeIntervalSinceNow</font>:(-3600.0f)]];  
    <font color="#547f85">PNDate</font> *endDate = [<font color="#547f85">PNDate</font> <font color="#38595d">dateWithDate</font>:[<font color="#7243a4">NSDate</font> <font color="#43277c">date</font>]];  
    <font color="#b7359d">int</font> limit = 34;  
    [<font color="#547f85">PubNub</font> <font color="#38595d">requestHistoryForChannel</font>:[<font color="#547f85">PNChannel</font> <font color="#38595d">channelWithName</font>:<font color="#cb3229">@"iosdev"</font>]  
                                <font color="#38595d">from</font>:startDate  
                                  <font color="#38595d">to</font>:endDate  
                               <font color="#38595d">limit</font>:limit  
                      <font color="#38595d">reverseHistory</font>:<font color="#b7359d">NO</font>  
                 <font color="#38595d">withCompletionBlock</font>:^(<font color="#7243a4">NSArray</font> *messages,  
                                       <font color="#547f85">PNChannel</font> *channel,  
                                       <font color="#547f85">PNDate</font> *startDate,  
                                       <font color="#547f85">PNDate</font> *endDate,  
                                       <font color="#547f85">PNError</font> *error) {  
                                       
                     <font color="#b7359d">if</font> (error == <font color="#b7359d">nil</font>) {  
                     
                         <font color="#008123">// Handle received messages history</font>
                     }  
                     <font color="#b7359d">else</font> {  
                     
                         <font color="#008123">// Handle history fetch error</font>
                     }  
                 }];
</pre>

<a name="error-handling"></a>
## Error handling

In the event of an error, the client will generate an instance of ***PNError***, which will include the error code (defined in PNErrorCodes.h), as well as additional information which is available via the `localizedDescription`,`localizedFailureReason`, and `localizedRecoverySuggestion` methods.  

In some cases, the error object will contain the "context instance object" via the `associatedObject` attribute.  This is the object  (such as a PNMessage) which is directly related to the error at hand.

<a name="event-handling"></a>
## Event handling

The client provides different methods of handling different events:  

1. Delegate callback methods  
2. Block callbacks
3. Observation center
4. Notifications  

### Delegate callback methods  

At any given time, there can be only one PubNub client delegate. The delegate class must conform to the [__PNDelegate__](pubnub/libs/PubNub/Misc/Protocols/PNDelegate.h) protocol in order to receive callbacks.  

Here is full set of callbacks which are available:
<pre>
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client error:(<font color="#547f85">PNError</font> *)error;  
    
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client willConnectToOrigin:(<font color="#7243a4">NSString</font> *)origin;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didConnectToOrigin:(<font color="#7243a4">NSString</font> *)origin;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didDisconnectFromOrigin:(<font color="#7243a4">NSString</font> *)origin;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didDisconnectFromOrigin:(<font color="#7243a4">NSString</font> *)origin withError:(<font color="#547f85">PNError</font> *)error;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client willDisconnectWithError:(<font color="#547f85">PNError</font> *)error;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client connectionDidFailWithError:(<font color="#547f85">PNError</font> *)error;  

- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didSubscribeOnChannels:(<font color="#7243a4">NSArray</font> *)channels;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client willRestoreSubscriptionOnChannels:(<font color="#7243a4">NSArray</font> *)channels;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didRestoreSubscriptionOnChannels:(<font color="#7243a4">NSArray</font> *)channels;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client subscriptionDidFailWithError:(<font color="#547f85">PNError</font> *)error;  

- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didUnsubscribeOnChannels:(<font color="#7243a4">NSArray</font> *)channels;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client unsubscriptionDidFailWithError:(<font color="#547f85">PNError</font> *)error;  

- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didEnablePresenceObservationOnChannels:(<font color="#7243a4">NSArray</font> *)channels;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client presenceObservationEnablingDidFailWithError:(<font color="#547f85">PNError</font> *)error;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didDisablePresenceObservationOnChannels:(<font color="#7243a4">NSArray</font> *)channels;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client presenceObservationDisablingDidFailWithError:(<font color="#547f85">PNError</font> *)error;

- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didEnablePushNotificationsOnChannels:(<font color="#7243a4">NSArray</font> *)channels;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client pushNotificationEnableDidFailWithError:(<font color="#547f85">PNError</font> *)error;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didDisablePushNotificationsOnChannels:(<font color="#7243a4">NSArray</font> *)channels;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client pushNotificationDisableDidFailWithError:(<font color="#547f85">PNError</font> *)error;
- (<font color="#b7359d">void</font>)pubnubClientDidRemovePushNotifications:(<font color="#547f85">PubNub</font> *)client;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client pushNotificationsRemoveFromChannelsDidFailWithError:(<font color="#547f85">PNError</font> *)error;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didReceivePushNotificationEnabledChannels:(<font color="#7243a4">NSArray</font> *)channels;
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client pushNotificationEnabledChannelsReceiveDidFailWithError:(<font color="#547f85">PNError</font> *)error;

- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didReceiveTimeToken:(<font color="#7243a4">NSNumber</font> *)timeToken;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client timeTokenReceiveDidFailWithError:(<font color="#547f85">PNError</font> *)error;  
 
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client willSendMessage:(<font color="#547f85">PNMessage</font> *)message;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didFailMessageSend:(<font color="#547f85">PNMessage</font> *)message withError:(<font color="#547f85">PNError</font> *)error;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didSendMessage:(<font color="#547f85">PNMessage</font> *)message;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didReceiveMessage:(<font color="#547f85">PNMessage</font> *)message;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didReceivePresenceEvent:(<font color="#547f85">PNPresenceEvent</font> *)event;  
    
- (<font color="#b7359d">void</font>)    pubnubClient:(<font color="#547f85">PubNub</font> *)client  
didReceiveMessageHistory:(<font color="#7243a4">NSArray</font> *)messages  
              forChannel:(<font color="#547f85">PNChannel</font> *)channel  
            startingFrom:(<font color="#547f85">PNDate</font> *)startDate  
                      to:(<font color="#547f85">PNDate</font> *)endDate;  
- (<font color="#b7359d">void</font>)pubnubClient:(<font color="#547f85">PubNub</font> *)client didFailHistoryDownloadForChannel:(<font color="#547f85">PNChannel</font> *)channel withError:(<font color="#547f85">PNError</font> *)error;  

- (<font color="#b7359d">void</font>)      pubnubClient:(<font color="#547f85">PubNub</font> *)client  
didReceiveParticipantsLits:(<font color="#7243a4">NSArray</font> *)participantsList  
                forChannel:(<font color="#547f85">PNChannel</font> *)channel;  

- (<font color="#b7359d">void</font>)                         pubnubClient:(<font color="#547f85">PubNub</font> *)client
    didFailParticipantsListDownloadForChannel:(<font color="#547f85">PNChannel</font> *)channel  
                                    withError:(<font color="#547f85">PNError</font> *)error;  
	                                
- (<font color="#7243a4">NSNumber</font> *)shouldReconnectPubNubClient:(<font color="#547f85">PubNub</font> *)client;  
- (<font color="#7243a4">NSNumber</font> *)shouldResubscribeOnConnectionRestore;
</pre>
	
### Block callbacks

Many of the client methods support callback blocks as a way to handle events in lieu of a delegate. For each method, only the last block callback will be triggered -- that is, in the case you send many identical requests via a handling block, only last one will register.  

### Observation center

[__PNObservationCenter__](3.4/pubnub/libs/PubNub/Core/PNObservationCenter.h) is used in the same way as NSNotificationCenter, but instead of observing with selectors it allows you to specify a callback block for particular events.  

These blocks are described in [__PNStructures.h__](3.4/pubnub/libs/PubNub/Misc/PNStructures.h).  

This is the set of methods which can be used to handle events:  
<pre>
- (<font color="#b7359d">void</font>)addClientConnectionStateObserver:(<font color="#b7359d">id</font>)observer  
                       withCallbackBlock:(<font color="#547f85">PNClientConnectionStateChangeBlock</font>)callbackBlock;
- (<font color="#b7359d">void</font>)removeClientConnectionStateObserver:(<font color="#b7359d">id)</font>observer;  

- (<font color="#b7359d">void</font>)addClientChannelSubscriptionStateObserver:(<font color="#b7359d">id</font>)observer  
                                withCallbackBlock:(<font color="#547f85">PNClientChannelSubscriptionHandlerBlock</font>)callbackBlock;  
- (<font color="#b7359d">void</font>)removeClientChannelSubscriptionStateObserver:(<font color="#b7359d">id</font>)observer;  
- (<font color="#b7359d">void</font>)addClientChannelUnsubscriptionObserver:(<font color="#b7359d">id</font>)observer  
                             withCallbackBlock:(<font color="#547f85">PNClientChannelUnsubscriptionHandlerBlock</font>)callbackBlock;  
- (<font color="#b7359d">void</font>)removeClientChannelUnsubscriptionObserver:(<font color="#b7359d">id</font>)observer;  

- (<font color="#b7359d">void</font>)addClientPresenceEnablingObserver:(<font color="#b7359d">id</font>)observer withCallbackBlock:(<font color="#547f85">PNClientPresenceEnableHandlingBlock</font>)handlerBlock;
- (<font color="#b7359d">void</font>)removeClientPresenceEnablingObserver:(<font color="#b7359d">id</font>)observer;
- (<font color="#b7359d">void</font>)addClientAsPresenceDisablingObserver:(<font color="#b7359d">id</font>)observer withCallbackBlock:(<font color="#547f85">PNClientPresenceDisableHandlingBlock</font>)handlerBlock;
- (<font color="#b7359d">void</font>)removeClientAsPresenceDisablingObserver:(<font color="#b7359d">id</font>)observer;

- (<font color="#b7359d">void</font>)addClientPushNotificationsEnableObserver:(<font color="#b7359d">id</font>)observer
                               withCallbackBlock:(<font color="#547f85">PNClientPushNotificationsEnableHandlingBlock</font>)handlerBlock;
- (<font color="#b7359d">void</font>)removeClientPushNotificationsEnableObserver:(<font color="#b7359d">id</font>)observer;
- (<font color="#b7359d">void</font>)addClientPushNotificationsDisableObserver:(<font color="#b7359d">id</font>)observer
                                withCallbackBlock:(<font color="#547f85">PNClientPushNotificationsDisableHandlingBlock</font>)handlerBlock;
- (<font color="#b7359d">void</font>)removeClientPushNotificationsDisableObserver:(<font color="#b7359d">id</font>)observer;

- (<font color="#b7359d">void</font>)addClientPushNotificationsEnabledChannelsObserver:(<font color="#b7359d">id</font>)observer
                                        withCallbackBlock:(<font color="#547f85">PNClientPushNotificationsEnabledChannelsHandlingBlock</font>)handlerBlock;
- (<font color="#b7359d">void</font>)removeClientPushNotificationsEnabledChannelsObserver:(<font color="#b7359d">id</font>)observer;
- (<font color="#b7359d">void</font>)addClientPushNotificationsRemoveObserver:(<font color="#b7359d">id</font>)observer
                               withCallbackBlock:(<font color="#547f85">PNClientPushNotificationsRemoveHandlingBlock</font>)handlerBlock;
- (<font color="#b7359d">void</font>)removeClientPushNotificationsRemoveObserver:(<font color="#b7359d">id</font>)observer;
	
- (<font color="#b7359d">void</font>)addTimeTokenReceivingObserver:(<font color="#b7359d">id</font>)observer  
                    withCallbackBlock:(<font color="#547f85">PNClientTimeTokenReceivingCompleteBlock</font>)callbackBlock;  
- (<font color="#b7359d">void</font>)removeTimeTokenReceivingObserver:(<font color="#b7359d">id</font>)observer;  
	
- (<font color="#b7359d">void</font>)addMessageProcessingObserver:(<font color="#b7359d">id</font>)observer withBlock:(<font color="#547f85">PNClientMessageProcessingBlock</font>)handleBlock;  
- (<font color="#b7359d">void</font>)removeMessageProcessingObserver:(<font color="#b7359d">id</font>)observer;  
- (<font color="#b7359d">void</font>)addMessageReceiveObserver:(<font color="#b7359d">id</font>)observer withBlock:(<font color="#547f85">PNClientMessageHandlingBlock</font>)handleBlock;  
- (<font color="#b7359d">void</font>)removeMessageReceiveObserver:(<font color="#b7359d">id</font>)observer;  
	
- (<font color="#b7359d">void</font>)addPresenceEventObserver:(<font color="#b7359d">id</font>)observer withBlock:(<font color="#547f85">PNClientPresenceEventHandlingBlock</font>)handleBlock;  
- (<font color="#b7359d">void</font>)removePresenceEventObserver:(<font color="#b7359d">id</font>)observer;  
	
- (<font color="#b7359d">void</font>)addMessageHistoryProcessingObserver:(<font color="#b7359d">id</font>)observer withBlock:(<font color="#547f85">PNClientHistoryLoadHandlingBlock</font>)handleBlock;  
- (<font color="#b7359d">void</font>)removeMessageHistoryProcessingObserver:(<font color="#b7359d">id</font>)observer;  
	
- (<font color="#b7359d">void</font>)addChannelParticipantsListProcessingObserver:(<font color="#b7359d">id</font>)observer  
                                           withBlock:(<font color="#547f85">PNClientParticipantsHandlingBlock</font>)handleBlock;  
- (<font color="#b7359d">void</font>)removeChannelParticipantsListProcessingObserver:(<font color="#b7359d">id</font>)observer;  
</pre>
	
### Notifications

The client also triggers notifications with custom user information, so from any place in your application you can listen for notifications and perform appropriate actions.

A full list of notifications are stored in [__PNNotifications.h__](3.4/pubnub/libs/PubNub/Misc/PNNotifications.h) along with their description, their parameters, and how to handle them.  

<a name="logging"></a>
### Logging

Logging can be controlled via the following booleans:  

<pre><font color="#754931">#define PNLOG_GENERAL_LOGGING_ENABLED 0
#define PNLOG_REACHABILITY_LOGGING_ENABLED 0
#define PNLOG_COMMUNICATION_CHANNEL_LAYER_ERROR_LOGGING_ENABLED 0
#define PNLOG_COMMUNICATION_CHANNEL_LAYER_INFO_LOGGING_ENABLED 0
#define PNLOG_COMMUNICATION_CHANNEL_LAYER_WARN_LOGGING_ENABLED 0
#define PNLOG_CONNECTION_LAYER_ERROR_LOGGING_ENABLED 0
#define PNLOG_CONNECTION_LAYER_INFO_LOGGING_ENABLED 0
</font>
</pre>

in [3.4/pubnub/libs/PubNub/Misc/PNMacro.h](3.4/pubnub/libs/PubNub/Misc/PNMacro.h#L37)

In the above example, all logging is disabled. By default, all logging is enabled.
