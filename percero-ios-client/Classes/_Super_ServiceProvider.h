//
//  _Super_ServiceProvider.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"
#import "PFModelObject.h"

@interface _Super_ServiceProvider : NSObject <Serializable, PFModelObject>{
    NSString* ID;
    NSDate* dateCreated;
    NSDate* dateModified;
    NSString* name;
    BOOL isShell;
}

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSDate* dateCreated;
@property(nonatomic, retain) NSDate* dateModified;
@property(nonatomic) BOOL isShell;

@end
