//
//  PutResponse.h
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "PFModelObject.h"
#import "SyncResponse.h"

@interface PutResponse : SyncResponse<Serializable>{
    
}

@property (nonatomic, assign) BOOL result;


@end
