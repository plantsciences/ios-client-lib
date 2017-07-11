//
//  CreateRequest.h
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//

#import "SyncRequest.h"
#import "PFModelObject.h"

@interface CreateRequest : SyncRequest

@property (nonatomic, weak) PFModelObject *theObject;

@end
