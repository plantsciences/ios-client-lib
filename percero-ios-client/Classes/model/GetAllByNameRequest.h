//
//  GetAllByNameRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncRequest.h"

@interface GetAllByNameRequest : SyncRequest{
    NSString* theClassName;
}

@property(nonatomic, retain) NSString* theClassName;

@end
