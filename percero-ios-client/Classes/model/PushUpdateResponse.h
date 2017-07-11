//
//  PushUpdateResponse.h
//  Percero
//
//  Created by Jeff Wolski on 3/13/13.
//
//

#import "SyncResponse.h"

@interface PushUpdateResponse : SyncResponse

@property (nonatomic, retain) NSMutableArray* result;

@end
