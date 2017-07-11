//
//  PFGoogleOauthViewController.m
//  OauthExperiment 2
//
//  Created by Jeff Wolski on 5/15/13.
//  Copyright (c) 2013 Organization Name. All rights reserved.
//

#import "PFGoogleOauthViewController.h"

@interface PFGoogleOauthViewController (){
    NSString *oauthURLString;
    NSString *oauthTokenURLString;
    NSString *oauthClientId;
    NSString *oauthRedirectURI;
    NSString *oauthClientSecret;//
    NSString *oauthScope;
    NSString *oauthState;
    
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *transitionView;
@end

@implementation PFGoogleOauthViewController


- (void) gotACode{
    // The PFOauthCompletedView nib shouold be in the client app, if not then use the default "Got a Code" meessage
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PFOauthCompletedView" ofType:@"nib"];
    
    if (path){
        self.transitionView = [[[NSBundle mainBundle] loadNibNamed:@"PFOauthCompletedView" owner:nil options:nil] lastObject];
        [self.view addSubview:self.transitionView];
    }
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    oauthURLString = @"https://accounts.google.com/o/oauth2/auth";
    oauthTokenURLString = @"https://www.googleapis.com/oauth2/v1/tokeninfo";
    oauthClientId = @"535733965646-pum47htns1oo41fh8en4np013lo286d3.apps.googleusercontent.com";
    oauthRedirectURI = @"http://prdnode.psiglobaldb.com:8080/PSIGlobal.html";
    oauthClientSecret = @"YKDoTOxWbzKon1BxBw5lNX0c";
    oauthScope = @"https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email http://www.google.com/m8/feeds https://apps-apis.google.com/a/feeds/groups/";
    oauthState = [[NSUUID UUID] UUIDString];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    [self.webView loadRequest:[self oauthURLRequest]];
}

- (NSURLRequest *) oauthURLRequest {
    
    NSString * urlString = oauthURLString;
    
    
    if (urlString) {
        
        if (oauthClientId) {
            urlString = [NSString stringWithFormat:@"%@?client_id=%@",urlString,oauthClientId];
            
            if (oauthRedirectURI) {
                urlString = [NSString stringWithFormat:@"%@&redirect_uri=%@",urlString,oauthRedirectURI];
            }
            
            if (oauthScope) {
                urlString = [NSString stringWithFormat:@"%@&scope=%@",urlString,oauthScope];
            }
            
            if (oauthState) {
                urlString = [NSString stringWithFormat:@"%@&state=%@",urlString,oauthState];
            }
            
            urlString = [NSString stringWithFormat:@"%@&response_type=%@",urlString,@"token"];

            
        } else{
            urlString = nil;
        }
    }
    
    NSURL * oauthURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * result = [NSURLRequest requestWithURL:oauthURL];
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void) requestAccessTokenWithCode:(NSString *) oauthCode{
    
    NSMutableURLRequest *oauthRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:oauthTokenURLString]];
    [oauthRequest setHTTPMethod: @"POST"];
    [oauthRequest setValue:@"text/html" forHTTPHeaderField:@"Content-type"];
    //    NSString * postString = [NSString stringWithFormat:@"client_id:%@&redirect_uri:%@&client_secret:%@&code:%@", oauthClientId, oauthRedirectURI, oauthClientSecret, oauthCode];
    NSString * postString = [NSString stringWithFormat:@"client_id:%@&client_secret:%@&code:%@", oauthClientId, oauthClientSecret, oauthCode];
    
    [oauthRequest setValue:[NSString stringWithFormat:@"%d", postString.length] forHTTPHeaderField:@"Content-length"];
    [oauthRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:oauthRequest returningResponse:&response error:&error];
    responseData = nil;
    //    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //    NSLog(@"responseData:%@",responseString);
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL shouldStart = YES;
    
    NSString * parametersString = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject] ;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    for (NSString *parameter in [parametersString componentsSeparatedByString:@"&"]) {
        NSArray *peices = [parameter componentsSeparatedByString:@"="];
        if([peices count] >= 2)
            parameters[peices[0]] = peices[1];
    }
    
        NSLog(@"url:%@", parameters);
    
    NSString *stateKey = [NSString stringWithFormat:@"%@#%@",oauthRedirectURI,@"state"];
    NSString *requestState = [parameters valueForKey:stateKey];
    NSString *errorString = [parameters valueForKey:@"error"];
    
    if (requestState) {
        if ([requestState isEqualToString:oauthState]){
            NSString *code = [parameters valueForKey:@"access_token"];
            if (code) {
                shouldStart = NO;
                
                [self requestAccessTokenWithCode:code];
                [self gotACode];
                [webView loadHTMLString:[NSString stringWithFormat: @"Got a code:%@",code] baseURL:nil];
                [self.delegate authenticationSucceededWithCode:code];
            }
        } else {
            shouldStart = NO;
            [webView loadHTMLString:@"States do not match!" baseURL:nil];
            [self.delegate authenticationFailed];
        }
    }
    
    
    if (errorString) {
        shouldStart = NO;
        [webView loadHTMLString:[NSString stringWithFormat: @"Got an error:%@", errorString] baseURL:nil];
        [self.delegate authenticationFailed];
        
    }
    
    
    
    return shouldStart;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

@end
