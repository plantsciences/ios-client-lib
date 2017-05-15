//
//  SyncManager.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFModelObject.h"
#import "PFSocketManager.h"
#import "EnvConfig.h"
#import "EntityManager.h"
#import "Utility.h"
#import "AuthRequest.h"
#import "SyncRequest.h"
#import "AuthResponse.h"
#import "SyncResponse.h"
#import "ConnectResponse.h"
#import "CreateRequest.h"
#import "CreateResponse.h"
#import "PushUpdateResponse.h"
#import "PushDeleteResponse.h"
#import "PutRequest.h"
#import "PutResponse.h"
#import "RemoveRequest.h"
#import "RemoveResponse.h"
#import "FindByIdRequest.h"
#import "FindByIdResponse.h"
#import "FindByExampleRequest.h"
#import "FindByExampleResponse.h"
#import "PushCWUpdateResponse.h"
#import "PushCWUpdateRequest.h"
#import "PFClient.h"
#import "PFPersistence.h"

@interface PFSocketManager () {
    NSTimer *messageTimer;
}

@property (nonatomic, readonly) NSMutableDictionary* syncRequests;

@end

static PFSocketManager* sharedInstance;

@implementation PFSocketManager
@synthesize socketIO, /*model,*/ isConnected;

- (void) notifyModelDidChange{
    
//    NSLog(@"notifyModelDidChange");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString* notificationName = [NSString stringWithFormat:@"modelDidChange"];
    [nc postNotificationName:notificationName object:self];
    
}
- (NSMutableDictionary *)syncRequests{
    static NSMutableDictionary* syncRequests;
    
    if (!syncRequests) {
        syncRequests = [[NSMutableDictionary alloc] initWithCapacity:8];
    }
    
    return syncRequests;
}
+ (PFSocketManager*) sharedInstance{
//    DLog(@"");
    if(!sharedInstance){
        sharedInstance = [[PFSocketManager alloc] init];
    }
    
    return sharedInstance;
}

- (void) connect{
    if(!isConnecting && !isConnected){
        /*
        * Setup the socket connection
        */
        EnvConfig* config = [EnvConfig sharedInstance];
        [socketIO connectToHost:[config getEnvProperty:@"socket.host"] onPort:[[config getEnvProperty:@"socket.port"] intValue]];
        isConnecting = true;
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (!isConnected) {
                isConnecting = NO;
                [self connect];
            }
        });
    }
}

- (id) init{
    self = [super init];
    if(self){
        isConnecting = false;
        callbacks = [[NSMutableDictionary alloc] init];
        socketIO = [[SocketIO alloc] initWithDelegate:self];

        [self connect];
    }
    return self;
}

- (void) messageTimer{

    static BOOL messageTimerIsLocked;
    if (messageTimerIsLocked) {
        return;
    }
    messageTimerIsLocked = YES;
    
    if (!messageTimer) {
        messageTimer = [[NSTimer alloc] init];
    }
    
    if ([messageTimer isValid]) {
        if (!self.syncRequests.count) {
            [messageTimer invalidate];
        } else {
            
            dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(backgroundQueue, ^{
                // check to see if any messages need to be resent
                static NSMutableArray *keysForTimedOutMessages;
                if (!keysForTimedOutMessages) {
                    keysForTimedOutMessages = [[NSMutableArray alloc] init];
                }
                [keysForTimedOutMessages removeAllObjects];
                [self.syncRequests enumerateKeysAndObjectsUsingBlock:^(id key, SyncRequest *request, BOOL *stop ) {
                    if ([request isKindOfClass:[SyncRequest class]]) {
                        if ([request.timeSent timeIntervalSinceNow] >= request.timeToRetry) {
                            // re-send request
                            [self sendEvent:request.eventName data:request callback:nil];
                        }
                        if ([request.timeSent timeIntervalSinceNow] >= request.timeToLive) {
                            [keysForTimedOutMessages addObject:key];
                        }
                    }
                    
                }];
                
                // get rid of timed-out requests
                for (id key in keysForTimedOutMessages) {
                    [self.syncRequests removeObjectForKey:key];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    // any UI or notifications should go here
                    
                });
                
                messageTimerIsLocked = NO;
            });
            
            
        }
    } else {
        if (!self.syncRequests.count) {
            // since the timer is invalid and there are no syncRequests, we do nothing
        } else {
            messageTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector( messageTimer) userInfo:nil repeats:YES];
        }
        
        messageTimerIsLocked = NO;
    }
    
    
} // messageTimer

- (void) cacheSyncRequest:(SyncRequest *) syncRequest{
    syncRequest.timeSent = [NSDate date];
    id <NSCopying> key = [syncRequest.messageId copy];
    self.syncRequests[key] = syncRequest;
    [self messageTimer];
}

- (void) processPushCWResponse:(PushCWUpdateResponse *) pushCWResponse {
    
    
    ClassIDPair *theTargetClassIdPair = [pushCWResponse valueForKey:@"classIDPair"];
    NSString * targetClassName = [Utility translateRemoteClassName:theTargetClassIdPair.className];
    NSString * targetId = theTargetClassIdPair.ID;
    PFModelObject *targetObject = [[EntityManager sharedInstance] entityForClass:targetClassName andId:targetId];
    id value = pushCWResponse.value;
    if (value) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray * newArray = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)value count]];
            for (id object in value) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    
                    PFModelObject *newObject = nil;
                    newObject = [[EntityManager sharedInstance] deserializeObject:object];
                    [newArray addObject:newObject];
                }
            }
            // this array should always be replaced instead of modified
            // and should be targeting a readOnly property
            value = [newArray copy];
        }
    }
    
    
    [targetObject setValue:value forKey:pushCWResponse.fieldName];
    
}

- (void) processSyncResponse:(SyncResponse *) syncResponse{

    id <NSCopying> key = [syncResponse.correspondingMessageId copy];

    if([syncResponse isKindOfClass:[ConnectResponse class]]){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"PFSocketReady" object:nil];
    }
    // check to see if there is a matching request
    SyncRequest *matchingRequest = self.syncRequests[key];
    
    if (matchingRequest) {
        // handle various response classes
        if ([syncResponse isKindOfClass:[PushCWUpdateResponse class]]) {
            [self processPushCWResponse:(PushCWUpdateResponse *)syncResponse];
            
        } else if ([syncResponse isKindOfClass:[CreateResponse class]]) {
            CreateResponse *createResponse = (CreateResponse *) syncResponse;
            CreateRequest *createRequest = (CreateRequest *)matchingRequest;
            if (createResponse.result) {
                // TODO: notify the user that the creation was successful
            } else {
                [createRequest.theObject delete];
                // TODO: notify the user that the creation failed
            }
            
        } else if ([syncResponse isKindOfClass:[PutResponse class]]) {
            PutResponse *putResponse = (PutResponse *) syncResponse;
            PutRequest *putRequest = (PutRequest *)matchingRequest;
            if (putResponse.result) {
                // TODO: notify the user that the Put was successful
            } else {
                // since the Put failed, we request an update from the server
                [putRequest.theObject requestUpdate];
                // TODO: notify the user that the Put failed
            }
        } else if ([syncResponse isKindOfClass:[RemoveResponse class]]) {
            RemoveResponse *removeResponse = (RemoveResponse *) syncResponse;
            RemoveRequest *removeRequest = (RemoveRequest *)matchingRequest;
            if (removeResponse.result) {
                // TODO: notify the user that the Put was successful
            } else {
                // since the Put failed, we request an update from the server
                [self.syncRequests setObject:removeRequest.removePair forKey:removeRequest.removePair.ID];
                [removeRequest.removePair requestUpdate];
                // TODO: notify the user that the Put failed
            }
        } else if ([syncResponse isKindOfClass:[FindByIdResponse class]]) {
            
            FindByIdResponse* findByIdResponse = (FindByIdResponse *) syncResponse;
            PFModelObject * foundObject = (PFModelObject *) findByIdResponse.result;
            
            
            id savedObject = [self.syncRequests valueForKey:foundObject.ID];
            if (savedObject) {
                [foundObject restoreDeletedRelationships];
                [self.syncRequests removeObjectForKey:foundObject.ID];
            }
            
            [PFPersistence addObject:foundObject];
            
            [self notifyModelDidChange];

        }else if ([syncResponse isKindOfClass:[FindByExampleResponse class]]) {
            FindByExampleResponse* findByExampleResponse = (FindByExampleResponse *) syncResponse;
            FindByExampleRequest* findByExampleRequest = (FindByExampleRequest *) matchingRequest;

            NSArray *result = findByExampleResponse.result;

            if((result.count == 1) && [findByExampleRequest.theObject conformsToProtocol:@protocol(IUserAnchor)]){
                PFModelObject<IUserAnchor> *requestUser = findByExampleRequest.theObject;
                PFModelObject<IUserAnchor> *responseUser = result[0];
                if ([requestUser.userId isEqualToString:responseUser.userId]) {
                    [[PFClient sharedInstance] setCurrentUser:responseUser];
                }
            }
            
            [self notifyModelDidChange];

            
        }
        
        // remove matchingRequest
        
        [self.syncRequests removeObjectForKey:key];
        
    } else {
        
        if ([syncResponse isKindOfClass:[PushUpdateResponse class]]) {
            PushUpdateResponse *pushUpdateResponse =(PushUpdateResponse *) syncResponse;
            for (PFModelObject *obj in pushUpdateResponse.result) {
                PFModelObject *dontLeaveMeLikeThisObject = [[EntityManager sharedInstance] getEntity:obj] ;
                [[EntityManager sharedInstance] addToInverseRelationshipsModelObject:dontLeaveMeLikeThisObject];

            }
            [self notifyModelDidChange];

        } else if ([syncResponse isKindOfClass:[PushCWUpdateResponse class]]) {
            
                [self processPushCWResponse:(PushCWUpdateResponse *)syncResponse];
                
            } else {
            // since we didn't request this and the server didn't push it, just ignore this request
        }
    
    }


}
/**
 * This method takes care of assigning a message Id and sending the object across the wire
 */
- (void) sendEvent:(NSString*)eventName data:(id<Serializable>)data callback:(PFInvocation *)inv {
    NSString* requestId = (__bridge_transfer NSString*) CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
    if([data isKindOfClass:[AuthRequest class]]){
        ((AuthRequest*)data).messageId = requestId;
    }
    else if([data isKindOfClass:[SyncRequest class]]){
        ((SyncRequest*)data).messageId = requestId;
        [self cacheSyncRequest:data];
    }

    if(inv){
        [callbacks setObject:inv forKey:requestId];
    }
    
    
    [socketIO sendEvent:eventName withData:[data toDictionary:NO]];
}

/**
 * Generic function for deserializing and sticking the proper objects
 * into the entity cache.
 */
- (id<Serializable>) deserializeObject:(id)obj{
    return [[EntityManager sharedInstance] deserializeObject:obj];    
}

/**************************
 * SocketIO Delegate Methods
 */
- (void) socketIODidConnect:(SocketIO *)socket{
    NSLog(@"Connected to socket!");
    isConnected = true;
    /**
     * Custom "connect" message required by PF Gateway
     */
    NSMutableDictionary* connectMessage = [[NSMutableDictionary alloc] init];
    
    if (self.lastSessionId) {
        [connectMessage setValue:@{@"ensureMessageDelivery":@(YES), @"lastSessionId":self.lastSessionId, @"reconnectId": self.reconnectID} forKey:@"reconnect"];
    } else {
        [connectMessage setValue:@{@"ensureMessageDelivery":@(YES)} forKey:@"connect"];
    }

    [socketIO sendEvent:@"message" withData:connectMessage];
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"PFSocketConnected" object:nil];
    
    self.lastSessionId = [socketIO valueForKey:@"_sid"];

    isConnecting = false;
}
- (void) socketIODidDisconnect:(SocketIO *)socket{
    NSLog(@"Disonnected from socket :(");
    
//    self.lastSessionId = [socketIO valueForKey:@"_sid"];
    isConnected = false;
    [self connect];
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet{
    NSLog(@"Got Message: %@", packet.data);
    
}
- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet{
    NSLog(@"didReceiveJSON: %@", packet);
}

/*
 * Method that gets called when a message is recieved from the socket
 */
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
    NSDictionary* data = [packet dataAsJSON];    
    NSArray* args = [data objectForKey:@"args"];
    id message = [args objectAtIndex:0]; // The real data is in the first element
    id<Serializable> result = [self deserializeObject:message];
    
    if([[packet name] isEqualToString:@"gatewayConnectAck"]){
        self.reconnectID = message;
    }
    
    if(result){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:[NSString stringWithFormat:@"didReceive%@", [[result class] description]] 
                          object:nil 
                        userInfo:[NSDictionary dictionaryWithObject:result forKey:@"response"]];
        
        NSString* corrMessageId;
        if([result isKindOfClass:[AuthResponse class]]){
            corrMessageId = ((AuthResponse*)result).correspondingMessageId;
        }
        else if([result isKindOfClass:[SyncResponse class]]){
            corrMessageId = ((SyncResponse*)result).correspondingMessageId;
            [self processSyncResponse:result];
        }
        
        if (corrMessageId && [corrMessageId isKindOfClass:[NSString class]]){
            // build ack
            NSDictionary *corrId = @{@"correspondingMessageId" : corrMessageId};
            NSDictionary *ack = @{@"ack": corrId};
            
            // send ack
            [socketIO sendJSON:ack];
        }
        
        PFInvocation* callback = [callbacks objectForKey:corrMessageId];
        if(callback){
            [callback invokeWithArgument:result];
            [callbacks removeObjectForKey:corrMessageId];
        }
    }
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet{
    NSLog(@"didSendMessage: %@", packet);    
}   


/**
 
 * Add a listener for the connect event
 */
+ (void) addListenerForConnectEvent:(NSObject*) target method:(SEL) selector{
    // Register any events that we are interested in.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:target selector:selector name:@"PFSocketConnected" object:nil];

}

/**
 * Add a listener for the ConnectResponse object, which is what signifies that we are read
 * to start sending traffic.
 */
+ (void) addListenerForReadyEvent:(NSObject*) target method:(SEL) selector{
    // Register any events that we are interested in.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:target selector:selector name:@"PFSocketReady" object:nil];
}


@end
