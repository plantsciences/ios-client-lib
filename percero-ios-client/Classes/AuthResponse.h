//
//  AuthResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface AuthResponse : NSObject <Serializable>{
    NSString* clientId;
	NSString* correspondingMessageId;
}

@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) NSString* correspondingMessageId;


@end
