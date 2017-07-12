//
//  GetRegAppOAuthsResponse.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetRegAppOAuthsResponse.h"
#import "EntityManager.h"

@implementation GetRegAppOAuthsResponse
@synthesize result;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        result = [[EntityManager sharedInstance] deserializeObject:[dict objectForKey:@"result"]];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:isShell];
    
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.GetRegAppOAuthsResponse";
}


@end
