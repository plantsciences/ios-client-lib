//
//  AuthenticateOAuthAccessTokenResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthResponse.h"
#import "UserToken.h"

@interface AuthenticateOAuthAccessTokenResponse : AuthResponse{
    UserToken* result;
    NSString* accessToken;
    NSString* refreshToken;
}

@property(nonatomic, retain) UserToken* result;
@property(nonatomic, retain) NSString* accessToken;
@property(nonatomic, retain) NSString* refreshToken;


@end
