//
//  PFViewController.m
//  percero-ios-client
//
//  Created by jonnysamps on 07/10/2017.
//  Copyright (c) 2017 jonnysamps. All rights reserved.
//

#import "PFViewController.h"
#import "Percero.h"

@interface PFViewController ()

@end

@implementation PFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) loginButtonTouched
{
  NSLog(@"Login Button Touched");
  [PFClient loginWithOAuthCode:@"" oauthKey:@"oauth.Google" callbackTarget:self method:@selector(authComplete)];
}

- (void) authComplete {
  
}

@end
