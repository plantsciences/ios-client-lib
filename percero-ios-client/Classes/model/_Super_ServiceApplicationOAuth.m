//
//  _Super_ServiceApplicationOAuth.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_ServiceApplicationOAuth.h"
#import "EntityManager.h"

@implementation _Super_ServiceApplicationOAuth
@synthesize appKey, ID, isDefault, oauthType, redirectUri, serviceApplication, isShell;

- (id) initWithId:(NSString *)identifier{
    self = [super init];
    if(self){
        ID = identifier;   
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        ID = [dict valueForKey:@"id"];
        appKey = [dict valueForKey:@"appKey"];
        isShell = appKey?YES:NO;
        //isDefault = [dict valueForKey:@"isDefault"];
        oauthType = [dict valueForKey:@"oauthType"];
        redirectUri = [dict valueForKey:@"redirectUri"];
        serviceApplication = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"serviceApplication"]];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)shell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!shell){
        [dict setValue:appKey forKey:@"appKey"];
        [dict setValue:oauthType forKey:@"oauthType"];
        [dict setObject:[serviceApplication toDictionary:YES] forKey:@"serviceApplication"];
        [dict setValue:redirectUri forKey:@"redirectUri"];
    }
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_ServiceApplicationOAuth class]]) {
        _Super_ServiceApplicationOAuth* casted = (_Super_ServiceApplicationOAuth*) object;
        
        appKey = casted.appKey;
        oauthType = casted.oauthType;
        redirectUri = casted.redirectUri;
        serviceApplication = casted.serviceApplication;
        isShell = casted.isShell;
    }
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.ServiceApplicationOAuth";
}



@end
