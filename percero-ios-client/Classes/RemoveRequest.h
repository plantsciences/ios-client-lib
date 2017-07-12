//
//  RemoveRequest.h
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//  Use this class to initiate the deletion of an object from the system.

#import "SyncRequest.h"
#import "ClassIDPair.h"

@interface RemoveRequest : SyncRequest <Serializable>

@property (nonatomic, strong) ClassIDPair *removePair;

@end
