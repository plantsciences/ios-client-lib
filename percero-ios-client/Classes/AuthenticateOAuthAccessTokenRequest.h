//
//  AuthenticateOAuthAccessTokenRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthRequest.h"

@interface AuthenticateOAuthAccessTokenRequest : AuthRequest{
    NSString* svcOauthKey;
    NSString* accessToken;
    NSString* refreshToken;
    NSString* redirectUri;
}

@property(nonatomic, retain) NSString* svcOauthKey;
@property(nonatomic, retain) NSString* accessToken;
@property(nonatomic, retain) NSString* refreshToken;
@property(nonatomic, retain) NSString* redirectUri;

@end
