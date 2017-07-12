//
//  FindByIdResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncResponse.h"
#import "PFModelObject.h"

@interface FindByIdResponse : SyncResponse<Serializable>{
    id<PFModelObject> result;
}

@property(nonatomic, retain) id<PFModelObject> result;

@end
