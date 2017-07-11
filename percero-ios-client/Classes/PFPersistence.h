//
//  PFPersistence.h
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import <Foundation/Foundation.h>
@class PFModelObject;
@interface PFPersistence : NSObject

+ (void)addObject:(id) object;

+ (void) sendFindByIdRequestWithRemoteClassName:(NSString*)remoteClassName objectId:(NSString*)objectId callBackTarget:(NSObject*) target callbackMethod:(SEL) selector;
+ (void) sendCreateRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendPutRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) setup;
@end
