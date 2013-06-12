//
//  main.m
//  pncl
//
//  Created by geremy cohen on 05/15/13.
//  Copyright (c) 2013 geremy cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "PNCLDelegate.h"

int main(int argc, const char *argv[]) {

    @autoreleasepool {


        PNCLDelegate * delegate = [[PNCLDelegate alloc] init];

        NSApplication * application = [NSApplication sharedApplication];
        [application setDelegate:delegate];
        [NSApp run];

    };
    return 0;

}
