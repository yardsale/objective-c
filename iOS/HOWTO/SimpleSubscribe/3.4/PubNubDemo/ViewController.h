//
//  ViewController.h
//  PubNubDemo
//
//  Created by geremy cohen on 3/27/13.
//  Copyright (c) 2013 geremy cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (void)onSubscribeComplete:(PNSubscriptionProcessState)state forChannels:(NSArray *)channels forError:(PNError *)error;
@end
