//
//  AuthRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface AuthRequest : NSObject <Serializable>{
    NSString* userId;
    NSString* token;
    NSString* clientType;
    NSString* clientId;
    NSString* deviceId;
    NSString* messageId;
    NSString* regAppKey;
    NSString* authProvider;
}

@property(nonatomic, strong) NSString* userId;
@property(nonatomic, strong) NSString* token;
@property(nonatomic, strong) NSString* clientType;
@property(nonatomic, strong) NSString* clientId;
@property(nonatomic, strong) NSString* deviceId;
@property(nonatomic, strong) NSString* messageId;
@property(nonatomic, strong) NSString* regAppKey;
@property(nonatomic, strong) NSString* authProvider;


@end

