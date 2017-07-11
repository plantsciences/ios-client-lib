//
//  CreateResponse.h
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//  This is the response form the server after the client sends a CreateRequest to create a new object.
//  The object in this resposne should be processed just like a requested object.

#import "SyncResponse.h"
#import "PFModelObject.h"

@interface CreateResponse : SyncResponse

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) id <PFModelObject> theObject;

@end
