//
//  PFGitHubOauthViewController.h
//  Percero
//
//  Created by Jeff Wolski on 4/16/13.
//
//

#import <UIKit/UIKit.h>

@protocol PFGitHubOauthDelegate <NSObject>

- (void) authenticationSucceededWithCode:(NSString *) code;
- (void) authenticationFailed;

@end

@interface PFOauthViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *oauthKey;
@property (nonatomic, weak) id<PFGitHubOauthDelegate> delegate;

@end
