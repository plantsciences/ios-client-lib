//
//  _Super_ServiceApplication.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_ServiceApplication.h"
#import "EntityManager.h"

@implementation _Super_ServiceApplication
@synthesize ID, appDomain, serviceProvider, registeredApplication, isShell;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        ID = [dict valueForKey:@"id"];
        appDomain = [dict valueForKey:@"appDomain"];
        isShell = appDomain?YES:NO;
        //isDefault = [dict valueForKey:@"isDefault"];
        serviceProvider = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"serviceProvider"]];
        registeredApplication = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"registeredApplication"]];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)shell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!shell){
        [dict setValue:appDomain forKey:@"appDomain"];
        [dict setObject:[serviceProvider toDictionary:YES] forKey:@"serviceProvider"];
        [dict setObject:[registeredApplication toDictionary:YES] forKey:@"registeredApplication"];
    }
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_ServiceApplication class]]) {
        _Super_ServiceApplication* casted = (_Super_ServiceApplication*) object;
        
        appDomain = casted.appDomain;
        serviceProvider = casted.serviceProvider;
        registeredApplication = casted.registeredApplication;
        isShell = casted.isShell;
    }
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.ServiceApplication";
}

@end
