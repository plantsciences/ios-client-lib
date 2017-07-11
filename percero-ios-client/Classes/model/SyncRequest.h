//
//  SyncRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

typedef enum {
    
    MESSAGE_TIME_TO_LIVE_DEFAULT = 42,  // 42 seconds
    MESSAGE_TIME_TO_LIVE_INDEFINITE  = 60 * 60 * 24 * 365,    // Times out after 1 year.
    MESSAGE_TIME_TO_RETRY_SHORT = 6,    // 6 seconds.
    MESSAGE_TIME_TO_RETRY_MEDIUM  = 20,   // 20 seconds.
    MESSAGE_TIME_TO_RETRY_LONG = 35,    // 35 seconds.
    MESSAGE_TIME_TO_RETRY_MAX = 2 * 60    // 2 minutes.
    
} MessageTime;

@interface SyncRequest : NSObject <Serializable>{
    NSString* userId;
	NSString* token;
    NSString* clientType;
	NSString* clientId;
	NSString* deviceId;
	NSString* responseChannel;
	NSString* messageId;
	NSString* regAppKey;
	NSString* svcOauthKey;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* token;
@property(nonatomic, retain) NSString* clientType;
@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) NSString* deviceId;
@property(nonatomic, retain) NSString* responseChannel;
@property(nonatomic, retain) NSString* messageId;
@property(nonatomic, retain) NSString* regAppKey;
@property(nonatomic, retain) NSString* svcOauthKey;
@property(nonatomic, assign) BOOL sendAck;
@property(nonatomic, strong) NSDate *timeSent;

+ (MessageTime) timeToLive;
+ (MessageTime) timeToRetry;
- (MessageTime) timeToLive;
- (MessageTime) timeToRetry;
- (NSString *) eventName;
@end
