//
//  _Super_ServiceApplication.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"
#import "Serializable.h"
#import "ServiceProvider.h"
#import "RegisteredApplication.h"

@interface _Super_ServiceApplication : NSObject <PFModelObject, Serializable>{
    NSString* ID;
    NSString* appDomain;
    ServiceProvider* serviceProvider;
    RegisteredApplication* registeredApplication;
    BOOL isShell;
}

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSString* appDomain;
@property(nonatomic, retain) ServiceProvider* serviceProvider;
@property(nonatomic, retain) RegisteredApplication* registeredApplication;
@property(nonatomic) BOOL isShell;

@end
