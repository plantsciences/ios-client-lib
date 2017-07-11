//
//  JsonObject.h
//  Percero
//
//  Created by Jeff Wolski on 7/22/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PFModelObject.h"

@interface JsonObject : NSManagedObject

@property (nonatomic, retain) NSData * jsonData;
@property (nonatomic, retain) NSString * jsonString;
@property (nonatomic, retain) NSString * nameOfClass;
@property (nonatomic, retain) NSString * objectId;

@end

@interface PFModelObject (JsonObject)
- (NSData *)jsonData;
+ (NSMutableDictionary *)dictionaryFromJsonData:(NSData *) jsonData;
@end