//
//  PFAuthManager.h
//  Percero
//
//  Created by Jeff Wolski on 4/16/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PFOauthViewController.h"
#import "PFInvocation.h"

@protocol PFAuthManagerDelegate <NSObject>

- (void) authenticationSucceeded;
- (void) authenticationFailed;

@end

@interface PFAuthManager : NSObject <PFGitHubOauthDelegate>
+ (NSArray *) oauthProviderKeys;
+ (void) loginWithOauthKeypath:(NSString *) keypath completionTarget:(UIViewController *)clientViewController;
+ (void) loginWithOauthCode:(NSString *) code keyPath:(NSString *)keyPath callbackTarget:(NSObject *)target method:(SEL)selector;
@property (nonatomic, weak) id<PFAuthManagerDelegate> delegate;

@end
