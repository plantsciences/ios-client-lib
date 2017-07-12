//
//  GetAllByNameResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncResponse.h"

@interface GetAllByNameResponse : SyncResponse{
    NSMutableArray* result;
}

@property (nonatomic, retain) NSMutableArray* result;

@end
