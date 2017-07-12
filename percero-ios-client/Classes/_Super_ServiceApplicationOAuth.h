//
//  _Super_ServiceApplicationOAuth.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"
#import "Serializable.h"
#import "ServiceApplication.h"

@class ServiceApplication;
@interface _Super_ServiceApplicationOAuth : NSObject <PFModelObject, Serializable>{
    NSString* ID;
    NSString* oauthType;
    NSString* appKey;
    NSString* redirectUri;
    ServiceApplication* serviceApplication;
    BOOL isDefault;
    BOOL isShell;
}

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSString* oauthType;
@property(nonatomic, retain) NSString* appKey;
@property(nonatomic, retain) NSString* redirectUri;
@property(nonatomic, retain) ServiceApplication* serviceApplication;
@property(nonatomic) BOOL isDefault;
@property(nonatomic) BOOL isShell;

@end
