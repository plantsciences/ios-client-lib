//
//  PFGoogleOauthViewController.h
//  OauthExperiment 2
//
//  Created by Jeff Wolski on 5/15/13.
//  Copyright (c) 2013 Organization Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFGoogleOauthDelegate <NSObject>

- (void) authenticationSucceededWithCode:(NSString *) code;
- (void) authenticationFailed;

@end

@interface PFGoogleOauthViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *oauthKey;
@property (nonatomic, weak) id<PFGoogleOauthDelegate> delegate;

@end
