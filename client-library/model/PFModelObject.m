//
//  PFModelObject.m
//  Percero
//
//  Created by Jeff Wolski on 3/22/13.
//

#import "PFModelObject.h"
#import "EntityManager.h"
#import "ClassIDPair.h"
#import "PFClient.h"
#import "Utility.h"
#import "PFPersistence.h"

@implementation PFModelObject

@synthesize ID, isShell, isLoading;

- (void)overwriteWith:(id<PFModelObject>)object{
    // do nothing
}

- (id)initFromDictionary:(NSDictionary *)dict{
	self = [super init];
    return self;
}


- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    return dict;
}

- (NSString *)remoteClassName{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}
+ (NSString *)remoteClassName{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}
- (void)save{
    
    if (self.ID) {
        [[EntityManager sharedInstance] updateObject:self];
    } else {
        self.ID = [[NSUUID UUID] UUIDString];
        [[EntityManager sharedInstance] createObject:self];
    }
}

- (void)requestUpdate{
    
        [PFPersistence sendFindByIdRequestWithRemoteClassName:self.remoteClassName objectId:self.ID callBackTarget:nil callbackMethod:nil];
}

- (void)delete{
	[[EntityManager sharedInstance] deleteObject:self];
}

- (void)restoreDeletedRelationships{
    
    // restore source relationship
    [[EntityManager sharedInstance] restoreDeletedRelationships:self];

    
}

- (void) getChangeWatcherWithFieldName:(NSString *) fieldName parameters:(NSArray *) parameters{

    [PFClient sendPushCWRequestWithEntity:self
                                fieldName:fieldName
                               parameters:parameters
                                   target:nil
                                   method:nil];
    
}

- (void) getChangeWatcherWithFieldName:(NSString *) fieldName parameters:(NSArray *) parameters callBackTarget:(NSObject*) target callbackMethod:(SEL) method{
    
    [PFClient sendPushCWRequestWithEntity:self
                                fieldName:fieldName
                               parameters:parameters
                                   target:target
                                   method:method];
    
}

+(void)requestServerSideDerivedCollectionWithRootObject:(id)rootObject
      changeWatcherFieldName:(NSString *)changeWatcherFieldName
                       param:(NSArray*)param
              callbackTarget:(id)callbackTarget
            callbackSelector:(SEL)callbackSelector{
    
    
    [rootObject getChangeWatcherWithFieldName:changeWatcherFieldName
                                   parameters:param
                               callBackTarget:callbackTarget
                               callbackMethod:callbackSelector];
}



-(ClassIDPair *)classIDPair{
    ClassIDPair *result = [[ClassIDPair alloc] init];
    
    result.className = self.remoteClassName;
    result.ID = ID;      
    return result;
}
+ (NSMutableArray *)all{
    NSString *className = [Utility translateRemoteClassName:[[self alloc] remoteClassName]];
    NSMutableDictionary *dict = [[EntityManager sharedInstance] dictionaryForClass:className];
    return [[dict allValues] mutableCopy];
}
+ (NSArray *)relationships {
    return @[];
}

@end