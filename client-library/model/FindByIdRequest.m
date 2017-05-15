//
//  FindByIdRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FindByIdRequest.h"

@implementation FindByIdRequest
@synthesize theClassId, theClassName;

- (id) init{
    self = [super init];
    if(self){
//        DLog(@"");
        theClassId = @"";
        theClassName = @"";
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        theClassId = [dict objectForKey:@"theClassId"];
        theClassName = [dict objectForKey:@"theClassName"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:theClassId  forKey:@"theClassId"];
        [dict setObject:theClassName  forKey:@"theClassName"];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.FindByIdRequest";
}

- (NSString *) eventName {
    return @"findById";
}


@end
