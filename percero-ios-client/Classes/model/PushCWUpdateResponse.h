//
//  PushCWUpdateResponse.h
//
//  Created by Jeff Wolski
//

#import "SyncResponse.h"
#import "ClassIDPair.h"

@interface PushCWUpdateResponse : SyncResponse<Serializable>

@property(nonatomic, retain) ClassIDPair* classIDPair;
@property(nonatomic, retain) NSString* fieldName;
@property(nonatomic, retain) NSArray* params;
@property(nonatomic, retain) id value;

@end