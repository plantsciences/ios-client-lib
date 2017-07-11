//
//  FindByIdRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncRequest.h"

@interface FindByIdRequest : SyncRequest
{
	NSString* theClassName;
    NSString* theClassId;
}

@property(nonatomic, retain) NSString* theClassName;
@property(nonatomic, retain) NSString* theClassId;

@end
