//
//  UIApplication+PNAdditions.h
//  pubnub
//
//  Created by Sergey Mamontov on 7/23/13.
//
//


#pragma mark Public interface declaration

@interface UIApplication (PNAdditions)


#pragma mark - Class methods

/**
 * Will check application Property List file to fetch whether application can run in background or not
 */
+ (BOOL)canRunInBackground;

#pragma mark -


@end
