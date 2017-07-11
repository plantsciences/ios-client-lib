//
//  PFGitHubOauthViewController.m
//  Percero
//
//  Created by Jeff Wolski on 4/16/13.
//
//

#import "PFOauthViewController.h"
#import "EnvConfig.h"


@interface PFOauthViewController (){
    NSString *oauthURLString;
    NSString *oauthTokenURLString;
    NSString *oauthClientId;
    NSString *oauthRedirectURI;
    NSString *oauthClientSecret;
    NSString *oauthScope;
    NSString *oauthState;
    PFOauthProviderType oauthProviderType;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *transitionView;

@end

@implementation PFOauthViewController

- (void) gotACode{
    // The PFOauthCompletedView nib shouold be in the client app, if not then use the default "Got a Code" meessage
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PFOauthCompletedView" ofType:@"nib"];
    
    if (path){
        self.transitionView = [[[NSBundle mainBundle] loadNibNamed:@"PFOauthCompletedView" owner:nil options:nil] lastObject];
        [self.view addSubview:self.transitionView];
    }
}

- (void) resetOauthEnvironment{
    
    NSDictionary *oauthDict = [EnvConfig oauthProviderDictForKey:self.oauthKey];

    oauthProviderType = [@"google" isEqualToString:oauthDict[@"paradigm"]]?PFOauthProviderTypeGoogle:PFOauthProviderTypeGitHub;

    oauthURLString = oauthDict[@"initialEndpointURL"];
    oauthTokenURLString = oauthDict[@"validationEndpointURL"];
    oauthClientId = oauthDict[@"client_id"];
    oauthRedirectURI = oauthDict[@"redirectUri"];
    oauthClientSecret = oauthDict[@"client_secret"];
    oauthScope = oauthDict[@"scope"];
    oauthState = [[NSUUID UUID] UUIDString];

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self resetOauthEnvironment];
}

- (void)viewWillAppear:(BOOL)animated{
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
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
            
            if (oauthProviderType == PFOauthProviderTypeGoogle) {
                urlString = [NSString stringWithFormat:@"%@&response_type=%@",urlString,@"code"];
            }
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
    
    NSString *stateKey = nil;
//    if (oauthProviderType == PFOauthProviderTypeGoogle) {
//        stateKey = [NSString stringWithFormat:@"%@#%@",oauthRedirectURI,@"state"];
//    } else if (oauthProviderType == PFOauthProviderTypeGitHub){
        stateKey = @"state";
//    }

    NSString *requestState = [parameters valueForKey:stateKey];
    NSString *errorString = [parameters valueForKey:@"error"];
    
    if (requestState) {
        if ([requestState isEqualToString:oauthState]){
            
            NSString *codeKey = nil;
//            if (oauthProviderType == PFOauthProviderTypeGoogle) {
//                codeKey = @"access_token";
//            } else if (oauthProviderType == PFOauthProviderTypeGitHub) {
                codeKey = @"code";
//            }
            
            NSString *code = [parameters valueForKey:codeKey];
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
