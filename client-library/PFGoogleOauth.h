//
//  PFGoogleOauth.h
//  PerceroFramework
//
//  Created by John Coumerilh on 2/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFGoogleOauth : NSObject
+ (void) setUp;
+ (void) listenForGoogleOauthWithSelector:(SEL)selector andTarget:(id)target;
+ (void) loginAndListenForCompletionWithSelector:(SEL)selector andTarget:(UIViewController *)clientViewController;
@end
                