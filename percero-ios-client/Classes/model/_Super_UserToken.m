//
//  _Super_UserToken.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_UserToken.h"
#import "EntityManager.h"
#import "User.h"

@implementation _Super_UserToken
@synthesize dateCreated,dateModified,ID,clientId,user,token,lastLogin,isShell;

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
        dateCreated = [dict valueForKey:@"dateCreated"];
        isShell = dateCreated?NO:YES;
        dateModified = [dict valueForKey:@"dateModified"];
        clientId = [dict valueForKey:@"clientId"];
        token = [dict valueForKey:@"token"];
        user = (User*) [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"user"]];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)shell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:ID forKey:@"ID"];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!shell){
        [dict setObject:dateCreated forKey:@"dateCreated"];
        [dict setObject:dateModified forKey:@"dateModified"];
        [dict setObject:clientId  forKey:@"clientId"];
        [dict setObject:[user toDictionary:YES] forKey:@"user"];
    }
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_UserToken class]]) {
        _Super_UserToken* casted = (_Super_UserToken*) object;
        
        dateCreated = casted.dateCreated;
        dateModified = casted.dateModified;
        clientId = casted.clientId;
        token = token = casted.token;
        isShell = casted.isShell;
    }
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.UserToken";
}

@end
