//
//  ClassIDPair.h
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "SyncRequest.h"
#import "PFModelObject.h"

@interface ClassIDPair : PFModelObject <Serializable>

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSDictionary *properties;

@end
