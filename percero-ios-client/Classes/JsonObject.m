//
//  JsonObject.m
//  Percero
//
//  Created by Jeff Wolski on 7/22/13.
//
//

#import "JsonObject.h"

@implementation JsonObject

@dynamic jsonData;
@dynamic jsonString;
@dynamic nameOfClass;
@dynamic objectId;

@end

@implementation PFModelObject (JsonObject)

- (NSData *)jsonData;
{
    NSError *errorJSON = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary:self.isShell] options:0/*NSJSONWritingPrettyPrinted*/ error:&errorJSON];
    return jsonData;
}

+ (NSMutableDictionary *)dictionaryFromJsonData:(NSData *) jsonData{
    NSMutableDictionary *result = nil;
    
    NSError *errorJSON = nil;
    result = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers | NSJSONWritingPrettyPrinted) error:&errorJSON];
    NSAssert([result isKindOfClass:[NSMutableDictionary class]], @"Result should have been an instance of NSMutableDicitonary");
    
    return result;
}

@end
