//
//  PNConfigurationTest.m
//  pubnub
//
//  Created by Sergey Mamontov on 7/6/13.
//
//


#import "PNConfigurationTest.h"
#import "PNDefaultConfiguration.h"


#pragma mark Private interface declaration

@interface PNConfigurationTest ()


#pragma mark - Instance methods

- (void)verifyDefaultValuesForConfiguration:(PNConfiguration *)configuration;


#pragma mark -


@end


#pragma mark - Public interface implementation

@implementation PNConfigurationTest


#pragma mark - Instance methods

- (void)setUp {
    
    [super setUp];
    
    NSLog(@"Setup \"%@\" test", self.name);
}

- (void)tearDown {
    
    [super tearDown];
    
    NSLog(@"Clean up after \"%@\" test", self.name);
}

- (void)verifyDefaultValuesForConfiguration:(PNConfiguration *)configuration {
    
    STAssertEqualObjects(configuration.origin, kPNOriginHost,
                         @"Origin host is not the same as configured in PNDefaultConfiguration.h");
    STAssertEqualObjects(configuration.publishKey, kPNPublishKey ? kPNPublishKey : @"",
                         @"Publish key is not the same as configured in PNDefaultConfiguration.h");
    STAssertEqualObjects(configuration.subscriptionKey, kPNSubscriptionKey ? kPNSubscriptionKey : @"",
                         @"Subscribe key is not the same as configured in PNDefaultConfiguration.h");
    STAssertEqualObjects(configuration.secretKey, kPNSecretKey ? kPNSecretKey : @"0",
                         @"Secret key is not the same as configured in PNDefaultConfiguration.h");
    STAssertEqualObjects(configuration.cipherKey, kPNCipherKey ? kPNCipherKey : @"",
                         @"Cipher key is not the same as configured in PNDefaultConfiguration.h");
    STAssertEqualObjects(configuration.authorizationKey, kPNAuthorizationKey ? kPNAuthorizationKey :@"",
                         @"Authorization key is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.shouldUseSecureConnection, kPNSecureConnectionRequired,
                   @"Secure connection flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.shouldAutoReconnectClient, kPNShouldAutoReconnectClient,
                   @"Autoreconnection flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.shouldReduceSecurityLevelOnError, kPNShouldReduceSecurityLevelOnError,
                   @"Security level reduce flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.canIgnoreSecureConnectionRequirement, kPNCanIgnoreSecureConnectionRequirement,
                   @"Security discard flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.shouldResubscribeOnConnectionRestore, kPNShouldResubscribeOnConnectionRestore,
                   @"Resubscribe on connection restore flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.shouldRestoreSubscriptionFromLastTimeToken, kPNShouldRestoreSubscriptionFromLastTimeToken,
                   @"Subscription restore from last timetoken flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.shouldAcceptCompressedResponse, kPNShouldAcceptCompressedResponse,
                   @"Compressed response acceptance flag is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.nonSubscriptionRequestTimeout, kPNNonSubscriptionRequestTimeout,
                   @"Non subscription timeout is not the same as configured in PNDefaultConfiguration.h");
    STAssertEquals(configuration.subscriptionRequestTimeout, kPNSubscriptionRequestTimeout,
                   @"Subscription timeout is not the same as configured in PNDefaultConfiguration.h");
}


#pragma mark - State tests

- (void)testDefaultConfigurationInit {
    
    PNConfiguration *configuration = [PNConfiguration defaultConfiguration];
    STAssertNotNil(configuration, @"Default configuration initilization failed.");
}

/**
 * Check whether default PNConfiguration instance values is the same as descirbed in 
 * PNDefaultConfiguration.h file.
 */
- (void)testDefaultConfigurationValues {
    
    PNConfiguration *configuration = [PNConfiguration defaultConfiguration];
    [self verifyDefaultValuesForConfiguration:configuration];
}

- (void)testCurrentConfiguration {
    
    PNConfiguration *configuration = [PNConfiguration defaultConfiguration];
    [PubNub setConfiguration:configuration];
    
    STAssertNotNil([PubNub currentConfiguration], @"Current configuration is nil");
    STAssertFalse(configuration == [PubNub currentConfiguration], @"Current PubNub configuration can't be same object used fot initial configuration");
}

- (void)testCurrentConfigurationDefaultValues {
    
    PNConfiguration *configuration = [PNConfiguration defaultConfiguration];
    [PubNub setConfiguration:configuration];
    [self verifyDefaultValuesForConfiguration:[PubNub currentConfiguration]];
}

#pragma mark -


@end
