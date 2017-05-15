//
//  PushCWUpdateRequest.h
//
//  Created by Jeff Wolski.
//

#import "SyncRequest.h"
#import "ClassIDPair.h"

@interface PushCWUpdateRequest : SyncRequest

@property(nonatomic, retain) ClassIDPair *classIDPair;
@property(nonatomic, retain) NSString* fieldName;
@property(nonatomic, retain) NSArray * params;
@end
