//
//  _Super_User.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_User.h"
#import "EntityManager.h"
#import "UserAccount.h"

@implementation _Super_User
@synthesize ID,dateCreated,dateModified,userAccounts, isShell;

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
        isShell = dateCreated?NO:YES;
        dateModified = [dict valueForKey:@"dateModified"];
        userAccounts = [[EntityManager sharedInstance] deserializeObject:[dict valueForKey:@"userAccounts"]];
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
        
        NSMutableArray* uaArray = [[NSMutableArray alloc] init];
        for (UserAccount* ua in userAccounts) {
            [uaArray addObject:[ua toDictionary:YES]];;
        }
        
        [dict setObject:uaArray forKey:@"userAccounts"];
    }
    
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_User class]]) {
        _Super_User* casted = (_Super_User*) object;
        
        dateCreated = casted.dateCreated;
        dateModified = casted.dateModified;
        userAccounts = casted.userAccounts;
        isShell = casted.isShell;
    }
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.User";
}

@end
