//
//  PFGoogleOauth.m
//  PerceroFramework
//
//  Created by John Coumerilh on 2/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import <Percero/Percero.h>
#import "PFGoogleOauth.h"
#import "GTMOAuth2ViewControllerTouch.h"

static PFGoogleOauth* sharedInstance=nil;

@interface PFGoogleOauth ()
@property (nonatomic, strong)ServiceApplicationOAuth* saOAuth;
@property (strong,nonatomic)  GTMOAuth2ViewControllerTouch *oathViewController;
@property (weak,nonatomic) UIViewController *clientViewController;
@property (assign, nonatomic) SEL loginCallbackSelector;
@property (assign, nonatomic) id pfGoogleOauthCallbackTarget;
@property (assign, nonatomic) SEL pfGoogleOauthCallbackSelector;
@property (assign, nonatomic) BOOL isAuthenticatedWithGoogle;
@end

@implementation PFGoogleOauth;


#pragma mark - Public Class Methods

+ (void) setUp{
    [PFGoogleOauth sharedInstance];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //Register for the "modelDidChangeServiceApplicationOAuth"
    [nc addObserver:[PFGoogleOauth sharedInstance]
           selector:@selector(modelDidChangeServiceApplicationOAuth:)
               name:@"modelDidChangeServiceApplicationOAuth"
             object:nil];
    [PFClient initialize];
}


+ (void) listenForGoogleOauthWithSelector:(SEL)selector andTarget:(id)target{
    
    if(target && selector){
        [PFGoogleOauth sharedInstance].pfGoogleOauthCallbackSelector=selector;
        [PFGoogleOauth sharedInstance].pfGoogleOauthCallbackTarget=target;
    }
    if ([PFGoogleOauth sharedInstance].isAuthenticatedWithGoogle){
        [[PFGoogleOauth sharedInstance] pfGoogleOAuthCompleted];
    }
}


+ (void) loginAndListenForCompletionWithSelector:(SEL)selector andTarget:(UIViewController *)clientViewController{
    
    [PFGoogleOauth sharedInstance].clientViewController=clientViewController;
    [PFGoogleOauth sharedInstance].loginCallbackSelector=selector;
    
    EnvConfig* config = [EnvConfig sharedInstance];
    
    GTMOAuth2ViewControllerTouch *viewController =
    [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[config getEnvProperty:@"oauth.com.psiglobaldb.scope"]
                                               clientID:[PFGoogleOauth sharedInstance].saOAuth.appKey
                                           clientSecret:@""
                                       keychainItemName:[config getEnvProperty:@"oauth.google.keychain_item_name"]
                                               delegate:[PFGoogleOauth sharedInstance]
                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [[PFGoogleOauth sharedInstance].clientViewController presentViewController:viewController animated:YES completion:nil];
}


#pragma mark - Private Class Methods

+ (PFGoogleOauth*) sharedInstance{
    if(sharedInstance==nil){
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}


#pragma mark

- (id) init{
    
    self = [super init];
    
    if(self && !sharedInstance){
        sharedInstance = self;
        self.isAuthenticatedWithGoogle=NO;
        self.loginCallbackSelector=nil;
        self.pfGoogleOauthCallbackSelector=nil;
        self.pfGoogleOauthCallbackTarget=nil;
    }
    return sharedInstance;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark - Callbacks/Notifications

- (void) modelDidChangeServiceApplicationOAuth:(NSNotification*)n{
    EntityManager* em = [EntityManager sharedInstance];
    NSDictionary* saOAuths = [em dictionaryForClass:@"ServiceApplicationOAuth"];
    for (NSString* oa in saOAuths) {
        [PFGoogleOauth sharedInstance].saOAuth = [saOAuths valueForKey:oa];
        if([[PFGoogleOauth sharedInstance].saOAuth.serviceApplication.serviceProvider.name isEqualToString:@"google"]){
            [PFGoogleOauth sharedInstance].isAuthenticatedWithGoogle=YES;
            [[PFGoogleOauth sharedInstance] pfGoogleOAuthCompleted];
        }
    }
}


// This is the callback function that will be called when login OAuth completes.
// If success then we want to send the authCode to the server and start the login process there.
// If fail then report the failure.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    //[self.clientViewController dismissViewControllerAnimated:YES completion:nil];
    if (error != nil) {
        NSLog(@"OAuth Error: %@", error);
    } else {
        NSLog(@"OAuth Success!");
        [PFClient loginWithOAuthCode:[auth code] callbackTarget:[PFGoogleOauth sharedInstance] method:@selector(pfLoginCompleted:)];
    }
}



-(void) pfGoogleOAuthCompleted
{
    if([PFGoogleOauth sharedInstance].pfGoogleOauthCallbackTarget && [PFGoogleOauth sharedInstance].pfGoogleOauthCallbackSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[PFGoogleOauth sharedInstance].pfGoogleOauthCallbackTarget performSelector:[PFGoogleOauth sharedInstance].pfGoogleOauthCallbackSelector];
#pragma clang diagnostic pop
    }
}

    
-(void) pfLoginCompleted:(NSNumber*) result
{
    if([PFGoogleOauth sharedInstance].clientViewController && [PFGoogleOauth sharedInstance].loginCallbackSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[PFGoogleOauth sharedInstance].clientViewController performSelector:[PFGoogleOauth sharedInstance].loginCallbackSelector withObject:nil];
#pragma clang diagnostic pop
    }
}

@end
