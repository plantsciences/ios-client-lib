//
//  GetAllByNameRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetAllByNameRequest.h"

@implementation GetAllByNameRequest
@synthesize theClassName;

- (id) init{
    self = [super init];
    if(self){
        token = @"";
    }
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        theClassName = [dict objectForKey:@"theClassName"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:isShell];
    
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:theClassName forKey:@"theClassName"];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.GetAllByNameRequest";
}

- (NSString *) eventName {
    return @"getAllByName";
}



@end
