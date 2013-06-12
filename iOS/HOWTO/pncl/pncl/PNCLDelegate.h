//
// Created by geremy cohen on 5/15/13.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface PNCLDelegate : NSObject <PNDelegate, NSApplicationDelegate>
@property NSMutableArray *argv;
@property NSInteger argc;
@property NSSet *validOperations;

@property NSString *pnOp;

@property BOOL *sslMode;
@property BOOL *presence;

@property NSString *origin;
@property NSString *subKey;
@property NSString *pubKey;
@property NSString *cipherKey;
@property NSString *uuid;

@property NSArray *channels;
@property NSArray *pnChannels;
@property NSString *message;

@end
