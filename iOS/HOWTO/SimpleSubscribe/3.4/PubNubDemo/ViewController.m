//
//  ViewController.m
//  PubNubDemo
//
//  Created by geremy cohen on 3/27/13.
//  Copyright (c) 2013 geremy cohen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)onSubscribeComplete:(PNSubscriptionProcessState)state forChannels:(NSArray *)channels forError:(PNError *)error {
    
    
    switch(state) {

        case PNSubscriptionProcessNotSubscribedState:

            // Check whether 'subscriptionError' instance is nil or not (if not, handle error)
            break;
        case PNSubscriptionProcessSubscribedState:
            
            // Do something after subscription completed
            break;
        case PNSubscriptionProcessWillRestoreState:
            
            // Library is about to restore subscription on channels after connection went down and restored
            break;
        case PNSubscriptionProcessRestoredState:
            
            // Handle event that client completed resubscription
            break;
    }
    
    
    NSLog(@"channels: %@", channels);
    
    
    
    [PubNub requestParticipantsListForChannel:[PNChannel channelWithName:@"mp1"]
                          withCompletionBlock:^(NSArray *uuids,
                                                PNChannel *channel,
                                                PNError *error) {
                              if (error == nil) {
                                  
                                  for(NSString *uuid in uuids) {
                                      NSLog(uuid);
                                  }
                              }
                              else {
                                  
                                  // Handle participants request error
                              }
                          }];
    
    

    
    //                                 // wait 1 second
         int64_t delayInSeconds = 5.0;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             PNLog(PNLogGeneralLevel, self, @"enabling channels!!!");
              [PubNub enablePresenceObservationForChannels:channels];
         });
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PubNub setConfiguration:[PNConfiguration defaultConfiguration]];
    [PubNub setClientIdentifier:@"myUniqueID"];
    

    [PubNub connectWithSuccessBlock:^(NSString *origin) {
        PNLog(PNLogGeneralLevel, self, @"{BLOCK} PubNub client connected to: %@", origin);
        // wait 1 second
     
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // then subscribe on channel a
            // [PubNub subscribeOnChannel:[PNChannel channelWithName:@"a" shouldObservePresence:YES]];
        });
    
        PNChannel *sendChannelA, *sendChannelB, *sendChannelC, *sendChannelD = nil;
        sendChannelA = [PNChannel channelWithName:@"mp1" shouldObservePresence:YES];
       


//      sendChannel = [PNChannel channelWithName:@"mp1"];
        
        
        // Subscribe
        
        [PubNub subscribeOnChannel:sendChannelA withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *subscriptionError) {
            int64_t delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                PNLog(PNLogGeneralLevel, self, @"enabling channels!!!");
                [PubNub enablePresenceObservationForChannels:channels];
            });
        }];
        
//        [PubNub subscribeOnChannel:sendChannelB withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *subscriptionError) {
//            [self onSubscribeComplete:state forChannels:channels forError:subscriptionError];
//        }];
    
        //[PubNub subscribeOnChannel:sendChannelA];
        //[PubNub subscribeOnChannel:sendChannelB];

    
    }
     
     // In case of error you always can pull out error code and identify what happened and what you can do // additional information is stored inside error's localizedDescription, localizedFailureReason and
     // localizedRecoverySuggestion)
     
     
     
                         errorBlock:^(PNError *connectionError) {
//                             if (connectionError.code == kPNClientConnectionFailedOnInternetFailureError) {
//                                 // wait 1 second
//                                 int64_t delayInSeconds = 1.0;
//                                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                                     PNLog(PNLogGeneralLevel, self, @"Connection will be established as soon as internet connection will be restored");
//                                 }); }
//                             UIAlertView *connectionErrorAlert = [UIAlertView new]; connectionErrorAlert.title = [NSString stringWithFormat:@"%@(%@)",
//                                                                                                                  [connectionError localizedDescription],
//                                                                                                                  NSStringFromClass([self class])];
//                             connectionErrorAlert.message = [NSString stringWithFormat:@"Reason:\n%@\n\nSuggestion:\n%@",
//                                                             [connectionError localizedFailureReason],
//                                                             [connectionError localizedRecoverySuggestion]]; [connectionErrorAlert addButtonWithTitle:@"OK"];
//                             [connectionErrorAlert show];
                              }
     
     
     
                          ];
    
    
    /*
     
    [PubNub setConfiguration:[PNConfiguration defaultConfiguration]];
    [PubNub setClientIdentifier:@"myUniqueID"];

    [PubNub connectWithSuccessBlock:^(NSString *origin) {
        //Enable Presence 
        PNChannel *sendChannel = nil;
        
        //if(_channelsSet.appToGatewayChannel) {
        
        sendChannel = [PNChannel channelWithName:@"mp1" shouldObservePresence:YES];
        //[PubNub enablePresenceObservationForChannel:sendChannel];
        
        if([PubNub isPresenceObservationEnabledForChannel:sendChannel]) {
                NSLog(@"Send Channel Supports Presence");
            } else {
                NSLog(@"Send Channel Doesn't support Presence.");
            }
        //}
     */
        
    }

     

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
