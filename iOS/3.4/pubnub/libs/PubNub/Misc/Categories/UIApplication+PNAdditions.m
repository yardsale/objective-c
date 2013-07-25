//
//  UIApplication+PNAdditions.m
//  pubnub
//
//  Created by Sergey Mamontov on 7/23/13.
//
//


#import "UIApplication+PNAdditions.h"


#pragma mark Public interface implementation

@implementation UIApplication (PNAdditions)


#pragma mark - Class methods

+ (BOOL)canRunInBackground {

    static BOOL canRunInBackground;
    static dispatch_once_t dispatchOnceToken;
    dispatch_once(&dispatchOnceToken, ^{

        // Retrieve application information Property List
        NSDictionary *applicationInformation = [[NSBundle mainBundle] infoDictionary];

        if ([applicationInformation objectForKey:@"UIBackgroundModes"]) {

            NSArray *backgroundModes = [applicationInformation valueForKey:@"UIBackgroundModes"];
            NSArray *suitableModes = @[@"audio", @"location", @"voip", @"bluetooth-central", @"bluetooth-peripheral"];
            [backgroundModes enumerateObjectsUsingBlock:^(id mode, NSUInteger modeIdx, BOOL *modeEnumeratorStop) {

                canRunInBackground = [suitableModes containsObject:mode];
                *modeEnumeratorStop = canRunInBackground;
            }];
        }
    });


    return canRunInBackground;
}

#pragma mark -


@end
