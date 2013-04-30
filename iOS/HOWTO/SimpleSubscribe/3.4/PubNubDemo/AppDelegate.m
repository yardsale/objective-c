//
//  AppDelegate.m
//  PubNubDemo
//
//  Created by geremy cohen on 3/27/13.
//  Copyright (c) 2013 geremy cohen. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate
@synthesize alreadyConnected;

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog(@"PubNub client received message: %@", message);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [PubNub setDelegate:self];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)pubnubClient:(PubNub *)client didConnectToOrigin:(NSString *)origin {


        NSLog(@"---------------- SUBSCRIBE --------------");

        if (!alreadyConnected) {
            int64_t delayInSeconds = 2.0f;
            dispatch_time_t popTime =
                    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {


                PNChannel *sendChannel = [PNChannel channelWithName:@"a" shouldObservePresence:YES];
                [PubNub subscribeOnChannels:[PNChannel channelsWithNames:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]] withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *subscriptionError) { //self channels includes the send channel
                    //_hubConnected = YES;
                    NSLog(@"channels: %@", channels);

                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        int64_t delayInSeconds2 = 5.0f;
                        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 * NSEC_PER_SEC);
                        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void) {
                            NSLog(@"---------------- ENABLE PRESENCE ----------------");
                            [PubNub enablePresenceObservationForChannels:channels];

                            [PubNub requestParticipantsListForChannel:sendChannel withCompletionBlock:^(NSArray *participants, PNChannel *channel, PNError *error) {
                                if (error) {
                                    NSLog(@"Error grabbing participants: %@", error.localizedDescription);
                                } else {
                                    NSLog(@"participants: %@", participants);
                                    BOOL gatewayOnline = NO;
                                    for (NSString *uuid in participants) {
//                                if([_app.currentGateway.gatewayId isEqualToString:uuid]) {
//                                    gatewayOnline = YES;
//                                    break;
//                                }
                                    }

//                            _hubConnected = gatewayOnline;
//                            if(!_hubConnected) {
//                                NSError *error = [NSError errorWithDomain:@"Revolv" code:404 userInfo:@{NSLocalizedDescriptionKey: @"Gateway is not online."}];
//                                for(NSNumber *key in [_connectionErrorUpdateHandlers allKeys]) {
//                                    void(^update)(NSError *error) = [_connectionErrorUpdateHandlers objectForKey:key];
//                                    update(error);
//                                }
//                            }
                                }
                            }];
                        });
                    });

                }];
            });
        alreadyConnected = YES;
        }


}

@end
