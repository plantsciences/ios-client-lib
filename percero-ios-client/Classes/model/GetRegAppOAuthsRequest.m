//
//  GetRegAppOAuthsRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetRegAppOAuthsRequest.h"

@implementation GetRegAppOAuthsRequest
@synthesize regAppSecret, oauthType;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if(self){
        regAppSecret = [dict valueForKey:@"regAppSecret"];
        oauthType = [dict valueForKey:@"oauthType"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL) isShell{
    NSMutableDictionary* dict = [super toDictionary:isShell];

    [dict setObject:[self remoteClassName] forKey:@"cn"];
    [dict setObject:regAppSecret forKey:@"regAppSecret"];
    [dict setObject:oauthType forKey:@"oauthType"];
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.GetRegAppOAuthsRequest";
}


@end
