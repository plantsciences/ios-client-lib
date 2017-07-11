//
//  _Super_User.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"
#import "PFModelObject.h"

@interface _Super_User : NSObject <Serializable, PFModelObject>{
    NSString* ID;
    NSDate* dateCreated;
    NSDate* dateModified;
    NSArray* userAccounts;
    BOOL isShell;
}

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSDate* dateCreated;
@property(nonatomic, retain) NSDate* dateModified;
@property(nonatomic, retain) NSArray* userAccounts;
@property(nonatomic) BOOL isShell;


@end
