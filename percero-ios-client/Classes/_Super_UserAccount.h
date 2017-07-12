//
//  _Super_UserAccount.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"
#import "Serializable.h"

@class User;
@class ServiceProvider;

@interface _Super_UserAccount : NSObject <PFModelObject, Serializable>{
    NSString* ID;
    NSDate* dateCreated;
    NSDate* dateModified;
    User* user;
    ServiceProvider* serviceProvider;
    NSString* accessToken;
    NSString* refreshToken;
    NSString* accountId;
    BOOL isSupended;
    BOOL isAdmin;
    BOOL isShell;
}

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSDate* dateCreated;
@property (nonatomic, retain) NSDate* dateModified;
@property (nonatomic, retain) User* user;
@property (nonatomic, retain) ServiceProvider* serviceProvider;
@property (nonatomic, retain) NSString* accessToken;
@property (nonatomic, retain) NSString* refreshToken;
@property (nonatomic, retain) NSString* accountId;
@property (nonatomic) BOOL isSupended;
@property (nonatomic) BOOL isAdmin;
@property(nonatomic) BOOL isShell;


@end
