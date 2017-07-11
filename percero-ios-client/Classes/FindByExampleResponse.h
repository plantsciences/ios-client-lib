//
//  FindByExampleResponse.h
//  Percero
//
//  Created by Jeff Wolski on 4/22/13.
//
//

#import "SyncResponse.h"

@interface FindByExampleResponse : SyncResponse
@property (nonatomic, strong) NSArray *result;
@end
