//
//  PushDeletesReceivedRequest.h
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "SyncRequest.h"

@interface PushDeletesReceivedRequest : SyncRequest<Serializable>

@property (nonatomic, strong) NSArray *classIDPairs;

@end
