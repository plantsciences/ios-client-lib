//
//  SyncRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncRequest.h"

@implementation SyncRequest
@synthesize token,clientId,userId,messageId,clientType,responseChannel,deviceId,regAppKey,svcOauthKey;

- (id) init{
    self = [super init];
    if(self){
        DLog(@"");
        token = @"";
        clientId = @"";
        deviceId = @"";
        userId = @"";
        messageId = @"";
        clientType = @"";
        responseChannel = @"";
        regAppKey = @"";
        svcOauthKey = @"";
        _sendAck = NO;
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        token = [dict objectForKey:@"token"];
        clientId = [dict objectForKey:@"clientId"];
        deviceId = [dict objectForKey:@"deviceId"];
        userId = [dict objectForKey:@"userId"];
        messageId = [dict objectForKey:@"messageId"];
        clientType = [dict objectForKey:@"clientType"];
        responseChannel = [dict objectForKey:@"responseChannel"];
        regAppKey = [dict objectForKey:@"regAppKey"];
        svcOauthKey = [dict objectForKey:@"svcOauthKey"];
        _sendAck = [dict[@"sendAck"] boolValue];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:token forKey:@"token"];
        [dict setObject:clientId forKey:@"clientId"];
        [dict setObject:deviceId forKey:@"deviceId"];
        [dict setObject:userId  forKey:@"userId"];
        [dict setObject:messageId  forKey:@"messageId"];
        [dict setObject:clientType  forKey:@"clientType"];
        [dict setObject:responseChannel  forKey:@"responseChannel"];
        [dict setObject:regAppKey  forKey:@"regAppKey"];
        [dict setObject:svcOauthKey  forKey:@"svcOauthKey"];
        dict[@"sendAck"] = @(_sendAck);
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.SyncRequest";
}

+ (MessageTime)timeToLive{
    return MESSAGE_TIME_TO_LIVE_DEFAULT;
}

+ (MessageTime)timeToRetry{
    return MESSAGE_TIME_TO_RETRY_MEDIUM;
}

- (MessageTime)timeToLive{
    return [self.class timeToLive];
}

- (MessageTime)timeToRetry{
    return [self.class timeToRetry];
}

- (NSString *)eventName{
    [NSException raise:@"Not implemented" format:@"%@ needs to be implemented in %@", @"eventName", [self.class description]];
    return nil;
}
@end
