//
//  AuthenticateOAuthAccessTokenResponse.m
//  SocketConnect
//
//  Created by Jonathan Samples on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateOAuthAccessTokenResponse.h"
#import "EntityManager.h"

@implementation AuthenticateOAuthAccessTokenResponse
@synthesize accessToken, refreshToken, result;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        accessToken = [dict valueForKey:@"accessToken"];
        refreshToken = [dict valueForKey:@"refreshToken"];
        result = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"result"]];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSDictionary* dict = [super toDictionary:isShell];
    [dict setValue:[self remoteClassName] forKey:@"cn"];
    if(!isShell){
        [dict setValue:accessToken forKey:@"accessToken"];
        [dict setValue:refreshToken forKey:@"refreshToken"];
        [dict setValue:[result toDictionary:NO] forKey:@"result"];
    }
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.AuthenticateOAuthAccessTokenResponse";
}


@end
