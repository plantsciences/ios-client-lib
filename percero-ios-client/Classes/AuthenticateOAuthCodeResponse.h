//
//  AuthenticateOAuthCodeResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthResponse.h"
@class UserToken;
@interface AuthenticateOAuthCodeResponse : AuthResponse{
    UserToken* result;
    NSString* accessToken;
    NSString* refreshToken;
}

@property(nonatomic, retain) UserToken* result;
@property (nonatomic, retain) NSString* refreshToken;
@property (nonatomic, retain) NSString* accessToken;


@end
