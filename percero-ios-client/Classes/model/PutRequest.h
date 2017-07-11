//
//  PutRequest.h
//  Percero
//
//  Created by Jeff Wolski on 3/14/13.
//
//

#import "SyncRequest.h"
#import "PFModelObject.h"

@interface PutRequest : SyncRequest

@property PFModelObject *theObject;
@property long long putTimestamp;
@property NSString* transId;

@end
