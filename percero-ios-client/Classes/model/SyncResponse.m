//
//  SyncResponse.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncResponse.h"

@implementation SyncResponse
@synthesize clientId, data,type,gatewayMessageId,correspondingMessageId;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        clientId = [dict objectForKey:@"clientId"];
        data = [dict objectForKey:@"data"];
        type = [dict objectForKey:@"type"];
        gatewayMessageId = [dict objectForKey:@"gatewayMessageId"];
        correspondingMessageId = [dict valueForKey:@"correspondingMessageId"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:clientId forKey:@"clientId"];
        [dict setObject:data forKey:@"data"];
        [dict setObject:type  forKey:@"type"];
        [dict setObject:gatewayMessageId forKey:@"gatewayMessageId"];
        [dict setObject:correspondingMessageId forKey:@"correspondingMessageId"];
    }
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.SyncResponse";
}


@end
