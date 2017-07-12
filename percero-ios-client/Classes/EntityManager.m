//
//  EntityManager.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityManager.h"
#import "PFModelObject.h"
#import "Utility.h"
#import "FindByIdRequest.h"
#import "PFSocketManager.h"
#import "PFClient.h"
#import "PFTargetRelationship.h"
#import "PFSourceRelationship.h"
#import "PFPersistence.h"

static EntityManager* sharedInstance;

@implementation EntityManager

- (id) init{
    self = [super init];
    if(self){
        entityModel = [[NSMutableDictionary alloc] init];
        sharedInstance = self;
    }
    
    return self;
}

+ (EntityManager*) sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[EntityManager alloc] init];
    }
    
    return sharedInstance;
}

/**
 * Use this method to fetch a specific Object from the model cache.
 */
- (id<PFModelObject>) entityForClass:(NSString*) c andId:(NSString*)identifier{
    NSMutableDictionary* classDict = [entityModel objectForKey:c];
    id<PFModelObject> object = [classDict objectForKey:identifier];
    
    return object;
}


/**
 * Use this method to get entity objects in the model.  If the object passed in
 * doesn't yet exist in the model cache then cache it.
 */
- (id<PFModelObject>) getEntity:(id<PFModelObject>)entity{
    NSMutableDictionary* classDict = [entityModel objectForKey:[[entity class] description]];
    
    // If we don't have a dictionary for this class yet, then create one
    if(!classDict){
        classDict = [[NSMutableDictionary alloc] init];
        [entityModel setObject:classDict forKey:[[entity class] description]];
    }
    
    id<PFModelObject> old = [classDict objectForKey:[entity ID]];
    
    // If the new one is not a shell then overwrite the old with the new
    if(old && ![entity isShell]){
        [old overwriteWith:entity];
    }
    // If the entity is not cached yet, then cache it
    else if(!old){
        [classDict setValue:entity forKey:[entity ID]];
        
        //      I don't know if we need this or not.  Was using it to notify the controller logic that an object had entered the model cache.
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSString* notificationName = [NSString stringWithFormat:@"modelDidChange%@", [[entity class] description]];
        [nc postNotificationName:notificationName object:self];
    }

    old = [classDict objectForKey:[entity ID]];
    
    return old;
}

- (NSMutableDictionary*) dictionaryForClass:(NSString*) c{
    NSMutableDictionary *dict = [entityModel objectForKey:c];
    if (!dict) {
        NSString *name = [[NSClassFromString(c) alloc] remoteClassName];
        [PFClient sendGetAllByNameRequest:name target:nil method:nil];
    }
    return dict;
}

- (id) deserializeObject:(id) obj{
    id <Serializable> result;
    if([obj isKindOfClass:[NSDictionary class]]){
        BOOL isShell = NO;

        NSString* className = [obj objectForKey:@"cn"];
        // className is used for shell objects, cn for non-shell objects
        if(!className){
            className = [obj objectForKey:@"className"];
            isShell = YES;
        }
        
        if(!className){
            NSLog(@"unable to deserialize object.  Could not find classname.");
            return nil;
        }
        
        Class c = NSClassFromString([Utility translateRemoteClassName:className]);
        result = [c alloc];
        result = [result initFromDictionary:obj];
        if ([result conformsToProtocol:@protocol(PFModelObject)]){
            ((id<PFModelObject>)result).isShell = isShell;
        }
        // If the object 
        if([result conformsToProtocol:@protocol(PFModelObject)]){
            result = (id<Serializable>) [self getEntity:(id<PFModelObject>)result];
        }
    }
    else if([obj isKindOfClass:[NSArray class]]){
        NSMutableArray* obArray = [[NSMutableArray alloc] init];
                    
        for(id o in obj){
            id deserializedObject = [self deserializeObject:o];
            if (deserializedObject) [obArray addObject:deserializedObject];
        }
        
        result = (id <Serializable>)obArray;
    }
    
    return result;
} // deserializeObject:

- (void)removeFromInverseRelationsipsModelObject:(PFModelObject *)modelObject {
    // remove modelObject from all relationships
    NSArray *relationships = [[modelObject class] relationships];
    for (PFRelationship *relationship  in relationships) {
        if ([relationship isKindOfClass:[PFSourceRelationship class]]) {
            
            // source unidirectional relationships require no action
            if (!relationship.isUnidirectional) {
                if (relationship.isCollection) {
                    
                    PFModelObject *targetObject = [modelObject valueForKey:relationship.propertyName];
                    if (targetObject && !targetObject.isShell) {
                        NSMutableArray *collection = [targetObject mutableArrayValueForKey:relationship.inversePropertyName];
                        [collection removeObject:modelObject];
                    }
                    
                    
                } else {
                    PFModelObject *targetObject = [modelObject valueForKey:relationship.propertyName];
                    if (targetObject) {
                        [targetObject setValue:nil forKey:relationship.inversePropertyName];
                    }
                }
            }
            
            
            
        } else if ([relationship isKindOfClass:[PFTargetRelationship class]]){
            if (relationship.isUnidirectional) {
                {
                    // this relationship cannot be a collection
                    
                    //NSMutableDictionary * classDict =[[EntityManager sharedInstance] dictionaryForClass:relationship.inverseClassName];
                    NSMutableDictionary *classDict = [[EntityManager sharedInstance]->entityModel objectForKey:relationship.inverseClassName]; // To prevent triggering an unnecessary GetAllByNameRequest, we are bypassing the normal way of getting the class dictionary
                    for (PFModelObject *obj in classDict) {
                        if ([obj valueForKey:relationship.inversePropertyName] == modelObject){
                            [obj setValue:nil forKey:relationship.inversePropertyName];
                        }
                    }
                    
                    //[modelObject setValue:nil forKey:relationship.inversePropertyName];
                }
            } else {
                // target relationship is bi-directional
                if (relationship.isCollection) {
                    if (!modelObject.isShell) {
                        NSMutableArray *collection = [modelObject mutableArrayValueForKey:relationship.propertyName];
                        [collection removeObject:modelObject];
                    }
                    
                    
                } else {
                    PFModelObject *sourceObject = [modelObject valueForKey:relationship.propertyName];
                    [sourceObject setValue:nil forKey:relationship.inversePropertyName];
                }
            }
        }
    }
}

- (void) deleteObject:(PFModelObject *) modelObject{
    
    [self removeFromInverseRelationsipsModelObject:modelObject];
    
    
    
    // send RemoveRequest to server
    
    [PFClient sendRemoveRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:nil method:nil];
    
    
    // delete modelObject from class dictionary
    NSString *objectClass = [[modelObject class] description];
    NSMutableDictionary *dict = [self dictionaryForClass:objectClass];
    [dict removeObjectForKey:modelObject.ID];
    
    // post notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString* notificationName = [NSString stringWithFormat:@"modelDidChange%@", objectClass];
    [nc postNotificationName:notificationName object:self];
    
} // deleteObject:


- (void)restoreDeletedRelationships:(PFModelObject *)modelObject {
    NSMutableSet * affectedClasses = [[NSMutableSet alloc] init];
    // restore object for all relationships
    NSArray *relationships = [[modelObject class] relationships];
    for (PFRelationship *relationship  in relationships) {
        if ([relationship isKindOfClass:[PFSourceRelationship class]]) {
            
            // source unidirectional relationships require no action
            if (!relationship.isUnidirectional) {
                if (relationship.isCollection) {
                    
                    PFModelObject *targetObject = [modelObject valueForKey:relationship.propertyName];
                    if (targetObject && !targetObject.isShell) {
                        NSMutableArray *collection = [targetObject valueForKey:relationship.inversePropertyName];
                        NSUInteger thisObject = [collection indexOfObject:modelObject];
                        if (thisObject == NSNotFound) {
                            [collection addObject:modelObject];
                        }
                    }
                    
                    
                } else {
                    PFModelObject *targetObject = [modelObject valueForKey:relationship.propertyName];
                    if (targetObject) {
                        [targetObject setValue:modelObject forKey:relationship.inversePropertyName];
                    }
                }
            }
            
            
            
        } else if ([relationship isKindOfClass:[PFTargetRelationship class]]){
            if (relationship.isUnidirectional) {
                {
                    // this relationship cannot be a collection
                    
                    NSMutableDictionary *classDict = [[EntityManager sharedInstance]->entityModel objectForKey:relationship.inverseClassName]; // To prevent triggering an unnecessary GetAllByNameRequest, we are bypassing the normal way of getting the class dictionary
                    
                    // since we don't kow which objects may have been pointing to the model object,
                    // we request an update to every non-shell object of thos class
                    // TODO: we should modify the way a failing delete works so that we don't have to do this
                    for (PFModelObject *obj in classDict) {
                        if (!obj.isShell) {
                            [obj requestUpdate];
                        }
                    }
                    
                    //[modelObject setValue:nil forKey:relationship.inversePropertyName];
                }
            } else {
                // target relationship is bi-directional
                if (relationship.isCollection) {
                    if (!modelObject.isShell) {
                        NSMutableArray *collection = [modelObject valueForKey:relationship.propertyName];
                        NSUInteger thisObject = [collection indexOfObject:modelObject];
                        if (thisObject == NSNotFound) {
                            [collection addObject:modelObject];
                            [affectedClasses addObject:relationship.inverseClassName];
                        }

                    }
                    
                    
                } else {
                    PFModelObject *sourceObject = [modelObject valueForKey:relationship.propertyName];
                    [sourceObject setValue:modelObject forKey:relationship.inversePropertyName];
                    [affectedClasses addObject:relationship.inverseClassName];

                }
            }
        }
    }
    
    
    
        
    // post notifications
    for (NSString *className in affectedClasses) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSString* notificationName = [NSString stringWithFormat:@"modelDidChange%@", className];
        [nc postNotificationName:notificationName object:self];
    }
    NSString *objectClass = [[modelObject class] description];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString* notificationName = [NSString stringWithFormat:@"modelDidChange%@", objectClass];
    [nc postNotificationName:notificationName object:self];

} //restoreDeletedRelationships:

- (void)addToInverseRelationshipsModelObject:(PFModelObject<PFModelObject> *)modelObject{
    
    // add modelobject to all inverse relationships
    NSArray *relationships = [[modelObject class] relationships];
    for (PFRelationship *relationship  in relationships) {
        if ([relationship isKindOfClass:[PFSourceRelationship class]]) {
            
            // source unidirectional relationships require no action
            if (!relationship.isUnidirectional) {
                if (relationship.isCollection) {
                    
                    PFModelObject *targetObject = [modelObject valueForKey:relationship.propertyName];
                    if (targetObject && !targetObject.isShell) {
                        NSMutableArray *collection = [targetObject mutableArrayValueForKey:relationship.inversePropertyName];
                        NSUInteger index = [collection indexOfObject:modelObject];
                        if(index == NSNotFound)[collection addObject:modelObject];
                    }
                    
                    
                } else {
                    PFModelObject *targetObject = [modelObject valueForKey:relationship.propertyName];
                    if (targetObject) {
                        [targetObject setValue:modelObject forKey:relationship.inversePropertyName];
                    }
                }
            }
            
            
            
        } else if ([relationship isKindOfClass:[PFTargetRelationship class]]){
            if (relationship.isUnidirectional) {
                
//                // this relationship cannot be a collection
//                
//                //NSMutableDictionary * classDict =[[EntityManager sharedInstance] dictionaryForClass:relationship.inverseClassName];
//                NSMutableDictionary *classDict = [[EntityManager sharedInstance]->entityModel objectForKey:relationship.inverseClassName]; // To prevent triggering an unnecessary GetAllByNameRequest, we are bypassing the normal way of getting the class dictionary
//                for (PFModelObject *obj in classDict) {
//                    if ([obj valueForKey:relationship.inversePropertyName] == modelObject){
//                        [obj setValue:nil forKey:relationship.inversePropertyName];
//                    }
//                }
//                
//                //[modelObject setValue:nil forKey:relationship.inversePropertyName];
                
            } else {
                // target relationship is bi-directional
                if (relationship.isCollection) {
//                    if (!modelObject.isShell) {
//                        NSMutableArray *collection = [modelObject mutableArrayValueForKey:relationship.propertyName];
//                        NSUInteger index = [collection indexOfObject:modelObject];
//                        if(index == NSNotFound){
//                            [collection addObject:modelObject];
//                        }
//                    }
                
                    
                } else {
                    PFModelObject *sourceObject = [modelObject valueForKey:relationship.propertyName];
                    [sourceObject setValue:modelObject forKey:relationship.inversePropertyName];
                }
            }
        }
    }

} // setInverseRelationshipsForNewObject:

- (void)updateObject:(id<PFModelObject>)modelObject{
    [PFClient sendPutRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:nil method:nil];
}

- (void)updateObject:(id<PFModelObject>)modelObject withCompletionTarget:(id) target method:(SEL) method{
    [PFClient sendPutRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:target method:method];
}

- (void)createObject:(id<PFModelObject>)modelObject{
    
    PFModelObject *newObject = [self getEntity:modelObject];
    [self addToInverseRelationshipsModelObject:newObject];
    [PFClient sendCreateRequestWithClass:[newObject remoteClassName] object:newObject completionTarget:nil method:nil];

}

- (void)createObject:(id<PFModelObject>)modelObject withCompletionTarget:(id) target method:(SEL) method{
    [PFClient sendCreateRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:target method:method];
}

- (void) loadEntity:(id<PFModelObject>)entity{
    
//    PFClient* ad = [PFClient sharedInstance];
    [PFPersistence sendFindByIdRequestWithRemoteClassName:[entity remoteClassName] objectId:entity.ID callBackTarget:nil callbackMethod:nil];
    
    
//    FindByIdRequest* req = [[FindByIdRequest alloc] init];
//    req.theClassId = entity.ID;
//    req.theClassName = [entity remoteClassName];
//    req.clientId = ad.clientId;
//    req.userId = ad.userId;
//    
//    [[PFSocketManager sharedInstance] sendEvent:@"findById" data:req callback:nil];
}
- (void) didreceiveDelete{
    
}
/**
 * We have a helper function for setting up listeners for types of events that the EntityManager will emit
 * Specifically, the entity manager will emit an even for every object that it gets with the event name: didReceive{className}
 */
+ (void) addListenerForObjectType:(NSString*) className target:(NSObject*)target method:(SEL) selector{
    // Register any events that we are interested in.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
    [nc addObserver:target
           selector:selector 
               name:[NSString stringWithFormat:@"modelDidChange%@", className] 
             object:[self sharedInstance]];

}




@end
