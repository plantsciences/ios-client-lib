//
//  RemoveResponse.m
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//

#import "RemoveResponse.h"

@implementation RemoveResponse

- (id)initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if (self) {
        _result = [dict[@"result"] boolValue];
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    NSMutableDictionary *dict = [super toDictionary:isShell];
    
    if (dict) {
    
        dict[@"result"] = @(_result);
        
    }
    return dict;
}

@end
