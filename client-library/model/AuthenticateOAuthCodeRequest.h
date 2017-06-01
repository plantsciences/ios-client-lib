//
//  AuthenticateOAuthCodeRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthRequest.h"

@interface AuthenticateOAuthCodeRequest : AuthRequest{
	
    NSString* code;
	NSString* redirectUri;
    NSString* requestToken;
    NSString* requestSecret;
}

@property(nonatomic, retain) NSString* code;
@property(nonatomic, retain) NSString* redirectUri;
@property(nonatomic, retain) NSString* requestToken;
@property(nonatomic, retain) NSString* requestSecret;
@property(nonatomic, retain) NSString* oauthClientId;

@end

