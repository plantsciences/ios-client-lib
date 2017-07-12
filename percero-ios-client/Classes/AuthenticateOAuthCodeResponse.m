//
//  AuthenticateOAuthCodeResponse.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateOAuthCodeResponse.h"
#import "UserToken.h"
#import "EntityManager.h"

@implementation AuthenticateOAuthCodeResponse
@synthesize result, accessToken, refreshToken;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        result = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"result"]];
        accessToken = [dict valueForKey:@"accessToken"]; // store locally for autologin
        refreshToken = [dict valueForKey:@"refreshToken"]; // store locally for autologin
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSDictionary* dict = [super toDictionary:isShell];
    [dict setValue:[self remoteClassName] forKey:@"cn"];
    if(!isShell){
        [dict setValue:[result toDictionary:NO] forKey:@"result"];
        [dict setValue:accessToken forKey:@"accessToken"];
        [dict setValue:refreshToken forKey:@"refreshToken"];
    }
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.AuthenticateOAuthCodeResponse";
}


@end
