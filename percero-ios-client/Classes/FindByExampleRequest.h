//
//  FindByExampleRequest.h
//  Percero
//
//  Created by Jeff Wolski on 4/22/13.
//
//

#import "SyncRequest.h"
#import "PFModelObject.h"
#import "IUserAnchor.h"

@interface FindByExampleRequest : SyncRequest

@property(nonatomic, retain) PFModelObject<PFModelObject, IUserAnchor>* theObject;

@end
