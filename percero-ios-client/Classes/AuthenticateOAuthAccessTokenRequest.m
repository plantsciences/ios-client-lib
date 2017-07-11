//
//  AuthenticateOAuthAccessTokenRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateOAuthAccessTokenRequest.h"

@implementation AuthenticateOAuthAccessTokenRequest
@synthesize accessToken, svcOauthKey, refreshToken, redirectUri;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        refreshToken = [dict valueForKey:@"refreshToken"];
        redirectUri = [dict valueForKey:@"redirectUri"];
        svcOauthKey = [dict valueForKey:@"svcOauthKey"];
        accessToken = [dict valueForKey:@"accessToken"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSDictionary* dict = [super toDictionary:isShell];
    [dict setValue:[self remoteClassName] forKey:@"cn"];
    if(!isShell){
        [dict setValue:refreshToken forKey:@"refreshToken"];
        [dict setValue:redirectUri forKey:@"redirectUri"];
        [dict setValue:accessToken forKey:@"accessToken"];
        [dict setValue:svcOauthKey forKey:@"svcOauthKey"];
        
    }
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.AuthenticateOAuthAccessTokenRequest";
}


@end
