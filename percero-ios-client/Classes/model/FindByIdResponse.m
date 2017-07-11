//
//  FindByIdResponse.m
//  SocketConnect
//
//  Created by Jonathan Samples on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindByIdResponse.h"
#import "EntityManager.h"

@implementation FindByIdResponse
@synthesize result;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        result = [[EntityManager sharedInstance] deserializeObject:[dict objectForKey:@"result"]];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:[result toDictionary:YES] forKey:@"result"];
    }
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.FindByIdResponse";
}


@end
