//
//  SyncResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"
@interface SyncResponse : NSObject <Serializable>{
    NSString* clientId;
	NSMutableArray* ids;
	id data;
	NSString* type;
	NSString* correspondingMessageId;
	NSString* gatewayMessageId;
}

@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) id data;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, retain) NSString* correspondingMessageId;
@property(nonatomic, retain) NSString* gatewayMessageId;

@end
