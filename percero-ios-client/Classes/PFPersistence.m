//
//  PFPersistence.m
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import "PFPersistence.h"
#import "FindByIdRequest.h"
#import "PFClient.h"
#import "PFInvocation.h"
#import "PFSocketManager.h"
#import <UIKit/UIKit.h>
#import "JsonObject.h"
#import "Utility.h"
#import "EntityManager.h"

@interface PFPersistence ()

@property (nonatomic, strong) UIManagedDocument *document;
+ (PFPersistence *) sharedInstance;

@end

static PFPersistence *_sharedInstance;

@implementation PFPersistence

NSString *entityName = @"JsonObject";

+ (void)setup {
    [self sharedInstance];
}
+ (void) sendFindByIdRequestWithRemoteClassName:(NSString*)remoteClassName objectId:(NSString*)objectId callBackTarget:(NSObject*) target callbackMethod:(SEL) selector{
    if ([PFClient isConnected]) {
        FindByIdRequest* request = [[FindByIdRequest alloc] init];
        [request setClientId:[PFClient sharedInstance].clientId];
        [request setToken:[PFClient sharedInstance].token];
        [request setUserId:[PFClient sharedInstance].userId];
        
        [request setTheClassName:remoteClassName];
        [request setTheClassId:objectId];
        
        PFInvocation* callback = nil;
        if(target && selector)
            callback = [[PFInvocation alloc] initWithTarget:target method:selector];
        
        [[PFSocketManager sharedInstance] sendEvent:@"findById" data:request callback:callback];
    } else {
        JsonObject *object = [self.class findObjectWithRemoteClassName:remoteClassName objectID:objectId];
        if (object) {
            NSMutableDictionary *objectDictionary = [PFModelObject dictionaryFromJsonData:object.jsonData];
            NSString *className = [Utility translateRemoteClassName:remoteClassName];
            Class objectClass = NSClassFromString(className);
            NSAssert([objectClass isSubclassOfClass:[PFModelObject class]], @"Should be a subclass of PFModelObject.");
            NSAssert([remoteClassName isEqualToString:[(PFModelObject *)objectClass remoteClassName]], @"Class name is not valid.");
            PFModelObject *properObject = [(PFModelObject *)[objectClass alloc] initFromDictionary:objectDictionary];
            [[EntityManager sharedInstance] getEntity:properObject]; // this will load the properObject into the memory cache
            
        }
    }
    
}
- (void) documentIsReady{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    //
}
- (id) init {
    
    if (self = [super init]) {
        NSString *documentName = @"MyDocument.md";
       
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:documentName];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                if (success) [self documentIsReady];
                if (!success) NSLog(@"couldn’t open document at %@", url);
            }]; } else {
                [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                       completionHandler:^(BOOL success) {
                           if (success) [self documentIsReady];
                           if (!success) NSLog(@"couldn’t create document at %@", url);
                       }];
            }
    }
    
    return self;
}
+ (JsonObject *) findObjectWithRemoteClassName:(NSString *) remoteClassName objectID:(NSString *) objectID{
    JsonObject *result = nil;
    
    PFPersistence *dataManager = [self sharedInstance];
    NSManagedObjectContext *moc = dataManager.document.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName]; request.fetchBatchSize = 20;
    
    NSPredicate *predicateNameOfClass = [NSPredicate predicateWithFormat:@"nameOfClass = %@", remoteClassName];
    NSPredicate *predicateObjectId = [NSPredicate predicateWithFormat:@"objectId = %@", objectID];
    NSPredicate *predicateCompound = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateNameOfClass, predicateObjectId]];
    request.predicate = predicateCompound;
    
    NSError *errorFetchRequest;
    NSArray *fetchResults = [moc executeFetchRequest:request error:&errorFetchRequest];
    if (fetchResults && fetchResults.count) {
        NSAssert(fetchResults.count == 1, @"Fetch should have returned 1 object instead of %d", fetchResults.count);
        result = fetchResults[0];
    }
    return result;
}


+ (void)addObject:(PFModelObject *) object
{
    if (![object isKindOfClass:[PFModelObject class]]) {
        return;
    }
    
    JsonObject *existingObject = [self findObjectWithRemoteClassName:object.remoteClassName objectID:object.ID];
    if (existingObject) {
        // if the object already exists, update the jsonData
        
        NSData *objectJasonData = object.jsonData;
        if (![objectJasonData isEqualToData:existingObject.jsonData])
        {
            existingObject.jsonData = objectJasonData;
            existingObject.jsonString = [[NSString alloc] initWithData:objectJasonData encoding:NSUTF8StringEncoding];
        }
        
    } else {
        // if the object does not yet exist, create a new one
        PFPersistence *dataManager = [self sharedInstance];
        NSManagedObjectContext *moc = dataManager.document.managedObjectContext;

        JsonObject *newObject = nil;

        newObject = [NSEntityDescription
                     insertNewObjectForEntityForName:entityName
                     inManagedObjectContext:moc];
        newObject.objectId = object.ID;
        newObject.nameOfClass = object.remoteClassName;
        NSData *jsonData;
        jsonData = object.jsonData;
        newObject.jsonData = jsonData;
        newObject.jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"newObject:%@", newObject);
        
    }
}

#pragma mark singleton

+ (PFPersistence *) sharedInstance{
    
    if (!_sharedInstance) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (id) copyWithZone:(NSZone *) zone{
    return self;
}

@end
