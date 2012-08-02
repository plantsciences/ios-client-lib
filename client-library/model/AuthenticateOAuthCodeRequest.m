//
//  AuthenticateOAuthCodeRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthenticateOAuthCodeRequest.h"

@implementation AuthenticateOAuthCodeRequest
@synthesize code,redirectUri,regAppKey,requestSecret,requestToken,svcOauthKey;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        code = [dict valueForKey:@"code"];
        redirectUri = [dict valueForKey:@"redirectUri"];
        regAppKey = [dict valueForKey:@"regAppKey"];
        requestSecret = [dict valueForKey:@"requestSecret"];
        requestToken = [dict valueForKey:@"requestToken"];
        svcOauthKey = [dict valueForKey:@"svcOauthKey"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSDictionary* dict = [super toDictionary:isShell];
    [dict setValue:[self remoteClassName] forKey:@"cn"];
    if(!isShell){
        [dict setValue:code forKey:@"code"];
        [dict setValue:redirectUri forKey:@"redirectUri"];
        [dict setValue:regAppKey forKey:@"regAppKey"];
        [dict setValue:requestSecret forKey:@"requestSecret"];
        [dict setValue:requestToken forKey:@"requestToken"];
        [dict setValue:svcOauthKey forKey:@"svcOauthKey"];
    }
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.AuthenticateOAuthCodeRequest";
}

@end
