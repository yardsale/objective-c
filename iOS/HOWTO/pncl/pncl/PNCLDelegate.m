//
// Created by geremy cohen on 5/15/13.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PNCLDelegate.h"
#import "PNMessage+Protected.h"


@implementation PNCLDelegate

@synthesize argv;
@synthesize argc;
@synthesize validOperations;

//@synthesize subKey, pubKey, cipherKey, channels, message;

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    NSLog(@"received message %@", message.message);
}

- (BOOL)applicationDidFinishLaunching:(NSNotification *)notification {
    [PubNub setDelegate:self];

    argv = [[NSMutableArray alloc] init];
    for (NSString *arg in [NSProcessInfo processInfo].arguments) {
        [argv addObject:[arg lowercaseString]];
    }

    argc = [argv count];
    validOperations = [NSSet setWithObjects:
            @"pub", @"publish", @"sub", @"subscribe", @"time", @"history", @"here_now", @"herenow", @"save", nil];

    [self validateCLOptions];
    [self setOptions];
    [self initPubNub];
    [self connectToOrigin];

    return YES;
}

- (void)connectToOrigin {
    [PubNub connectWithSuccessBlock:^(NSString *origin) {
        NSLog(@"Connected to %@", origin);
        [self issueCommand];
    }                    errorBlock:^(PNError *error) {
        NSLog(@"Error connecting.");
    }];
}

- (void)initPubNub {
    PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:_origin publishKey:_pubKey subscribeKey:_subKey secretKey:nil cipherKey:_cipherKey];
    [PubNub setConfiguration:myConfig];

    if ([_channels count] > 0) {
        _pnChannels = [PNChannel channelsWithNames:_channels];
    }
}

- (void)subscribe {
    if (_presence) {
        [PubNub subscribeOnChannels:_pnChannels withPresenceEvent:YES];
    } else {
        [PubNub subscribeOnChannels:_pnChannels];
    }
}

- (NSInteger)publish {
    if (_pubKey && _message) {
        [PubNub sendMessage:_message toChannel:[_pnChannels objectAtIndex:0] withCompletionBlock:^(PNMessageState state, id msgID) {
            NSLog(@"Sent");
//            while (1) {
//                if (state == PNMessageSent) {
//                    [NSApp terminate:self];
//                }
//            }
//            [NSApp terminate:self];
        }];
    } else {
        NSLog(@"FATAL: No message set. Provide a -m MESSAGE argument and try again.");
    }
    exit;
}
- (void)issueCommand {

    if ([[NSArray arrayWithObjects:@"sub", @"subscribe", nil] containsObject:_pnOp]) {
        [self subscribe];
    } else

    if ([[NSArray arrayWithObjects:@"pub", @"publish", nil] containsObject:_pnOp]) {
        [self publish];
    } else {
        NSLog(@"You set an operation, but you didn't form you commandline correctly. Try again!");
        [self printUsage];
        exit;
    }
}

- (void)validateCLOptions {

    if (argc == 1 || argv[1] && [[argv objectAtIndex:1] isEqualToString:@"-h"]) {
        [self printUsage];
        exit;
    }
    else if (![validOperations containsObject:[argv objectAtIndex:1]]) {
        [self printUsage];
        exit;
    } else if (![argv containsObject:@"-s"] && ![argv containsObject:@"-subkey"]) {
        NSLog(@"FATAL: No subKey set. Provide a -s SUBKEY argument and try again.");
        [self printUsage];
        exit;
    } else if (![argv containsObject:@"-c"] && ![argv containsObject:@"-channel"] && ![argv containsObject:@"-channels"]) {
        NSLog(@"FATAL: No channel set. Provide a -c CHANNEL(s) argument and try again.");
        [self printUsage];
        exit;
    }
}

- (void)setOptions {
    NSUserDefaults *clArgs = [NSUserDefaults standardUserDefaults];

    _pnOp = argv[1];

    if ([argv containsObject:@"ssl"] || [argv containsObject:@"withssl"]) {
        _sslMode = true;
    } else {
        _sslMode = false;
    }

    if ([argv containsObject:@"presence"] || [argv containsObject:@"withPresence"]) {
        _presence = true;
    } else {
        _presence = false;
    }

    if ([clArgs stringForKey:@"m"]) {
        _message = [clArgs stringForKey:@"m"];
    } else if ([clArgs stringForKey:@"message"]) {
        _message = [clArgs stringForKey:@"message"];
    } else {
        _message = nil;
    }

    if ([clArgs stringForKey:@"c"]) {
        _channels = [[clArgs stringForKey:@"c"] componentsSeparatedByString:@","];

    } else if ([clArgs stringForKey:@"channel"]) {
        _channels = [PNChannel channelsWithNames:[[clArgs stringForKey:@"channel"] componentsSeparatedByString:@","]];

    } else if ([clArgs stringForKey:@"channels"]) {
        _channels = [[clArgs stringForKey:@"channels"] componentsSeparatedByString:@","];
    } else {
        _channels = nil;
    }

    if ([clArgs stringForKey:@"cipherkey"]) {
        _cipherKey = [clArgs stringForKey:@"cipherkey"];
    } else {
        _cipherKey = nil;
    }

    if ([clArgs stringForKey:@"p"]) {
        _pubKey = [clArgs stringForKey:@"p"];
    } else if ([clArgs stringForKey:@"pubkey"]) {
        _pubKey = [clArgs stringForKey:@"pubkey"];
    } else {
        _pubKey = nil;
        NSLog(@"WARNING: No pubKey set. You will not be able to publish!");
    }

    if ([clArgs stringForKey:@"s"]) {
        _subKey = [clArgs stringForKey:@"s"];
    } else if ([clArgs stringForKey:@"subkey"]) {
        _subKey = [clArgs stringForKey:@"subkey"];
    } else {
        _subKey = nil;
        NSLog(@"WARNING: No subKey set.");

    }

    if ([clArgs stringForKey:@"o"]) {
        _origin = [clArgs stringForKey:@"o"];
    } else if ([clArgs stringForKey:@"origin"]) {
        _origin = [clArgs stringForKey:@"origin"];
    } else {
        _origin = @"pubsub.pubnub.com";
    }

    if ([clArgs stringForKey:@"u"]) {
        _uuid = [clArgs stringForKey:@"u"];
    } else if ([clArgs stringForKey:@"uuid"]) {
        _uuid = [clArgs stringForKey:@"uuid"];
    } else {
        _uuid = nil;
    }

    NSLog(@"Set CLI vars.");
}


- (void)printUsage {
    printf("pncl - PubNub from the command line! Usage:\n\n");
    printf("pncl <publish | pub | subscribe | sub | time | history | here_now> "
            "[-origin | -o ORIGIN] "
            "[-uuid | -u UUID] "
            "[-channel | -channels | -c CHANNEL] "
            "[-message | -m MESSAGE] "
            "[-cipherKey CIPHERKEY] "
            "[-withSSL | -ssl] "
            "[-subKey | -s SUBKEY] "
            "[-pubKey] | -p "
            "\n\n");
    printf("Set defaults ahead of time to jam!\n\n");

    printf("pncl save subkey SUBKEY\n");
    printf("pncl save pubkey PUBKEY\n");
    printf("pncl save secret SECRET\n");
    printf("pncl save cipherkey CIPHERKEY\n\n");
}

@end