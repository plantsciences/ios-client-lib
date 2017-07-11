//
//  SyncManager.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
#import "Serializable.h"
#import "PFInvocation.h"

@interface PFSocketManager : NSObject <SocketIODelegate>{
    SocketIO *socketIO;
    NSMutableDictionary* model;
    bool isConnected;
    bool isConnecting;
    NSMutableDictionary* callbacks;
}
@property (nonatomic , strong) NSString *reconnectID;
@property (nonatomic, readonly) SocketIO* socketIO;
//@property (nonatomic, readonly) NSMutableDictionary* model;
@property (nonatomic) bool isConnected;
@property (nonatomic, strong) NSString* lastSessionId;
+ (PFSocketManager*) sharedInstance;

- (void) sendEvent:(NSString*)eventName data:(id<Serializable>)data callback:(PFInvocation*) inv;
- (void) connect;
+ (void) addListenerForConnectEvent:(NSObject*) target method:(SEL) selector;
+ (void) addListenerForReadyEvent:(NSObject*) target method:(SEL) selector;


@end
