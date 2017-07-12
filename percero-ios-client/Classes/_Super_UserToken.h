//
//  _Super_UserToken.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"
#import "PFModelObject.h"

@class User;
@interface _Super_UserToken : NSObject <PFModelObject, Serializable>{
    NSString* ID;
    NSDate* dateCreated;
    NSDate* dateModified;
    NSDate* lastLogin;
    User* user;
    NSString* clientId;
    NSString* token;
    BOOL isShell;
}

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSDate* dateCreated;
@property (nonatomic, retain) NSDate* dateModified;
@property (nonatomic, retain) NSDate* lastLogin;
@property (nonatomic, retain) User* user;
@property (nonatomic, retain) NSString* clientId;
@property (nonatomic, retain) NSString* token;
@property (nonatomic) BOOL isShell;

@end
