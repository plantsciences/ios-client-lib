//
//  _Super_UserAccount.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_UserAccount.h"
#import "User.h"
#import "ServiceProvider.h"
#import "EntityManager.h"

@implementation _Super_UserAccount
@synthesize user,dateModified,ID,isAdmin,accountId,isSupended,accessToken,dateCreated,refreshToken,serviceProvider, isShell;

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
        ID = [dict valueForKey:@"ID"];
        dateCreated = [dict valueForKey:@"dateCreated"];
        isShell = dateCreated?YES:NO;
        dateModified = [dict valueForKey:@"dateModified"];
        user = [[User alloc] initFromDictionary:[dict valueForKey:@"user"]];
        //isAdmin = [dict valueForKey:@"isAdmin"];
        accountId = [dict valueForKey:@"accountId"];
        //isSupended = [dict valueForKey:@"isSupended"];
        accessToken = [dict valueForKey:@"accessToken"];
        refreshToken = [dict valueForKey:@"refreshToken"];
        serviceProvider = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"serviceProvider"]];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)shell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:ID forKey:@"ID"];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!shell){
        [dict setValue:ID forKey:@"ID"];
        [dict setValue:dateCreated forKey:@"dateCreated"];
        [dict setValue:dateModified forKey:@"dateModified"];
        [dict setValue:[user toDictionary:YES] forKey:@"user"];
        //[dict setValue: forKey:@"isAdmin"];
        [dict setValue:accountId forKey:@"accountId"];
        //[dict setValue: forKey:@"isSupended"];
        [dict setValue:accessToken forKey:@"accessToken"];
        [dict setValue:refreshToken forKey:@"refreshToken"];
        [dict setValue:[serviceProvider toDictionary:YES] forKey:@"serviceProvider"]; 
    }
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_UserAccount class]]) {
        _Super_UserAccount* casted = (_Super_UserAccount*) object;
        
        dateCreated = casted.dateCreated;
        dateModified = casted.dateModified;
        user = casted.user;
        isAdmin = casted.isAdmin;
        accountId = casted.accountId;
        isSupended = casted.isSupended;
        accessToken = casted.accessToken;
        refreshToken = casted.refreshToken;
        serviceProvider = casted.serviceProvider;
        isShell = casted.isShell;
    }
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.UserAccount";
}


@end
