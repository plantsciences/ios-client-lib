//
//  _Super_RegisteredApplication.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_RegisteredApplication.h"

@implementation _Super_RegisteredApplication
@synthesize ID, appName, isShell;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        ID = [dict valueForKey:@"id"];
        appName = [dict valueForKey:@"appName"];
        isShell = appName?YES:NO;
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)shell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!shell){
        [dict setValue:appName forKey:@"appName"];
    }
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_RegisteredApplication class]]) {
        _Super_RegisteredApplication* casted = (_Super_RegisteredApplication*) object;
        
        appName = casted.appName;
        isShell = casted.isShell;
    }
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.RegisteredApplication";
}


@end
