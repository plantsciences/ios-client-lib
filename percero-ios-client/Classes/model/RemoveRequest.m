//
//  RemoveRequest.m
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//

#import "RemoveRequest.h"

@implementation RemoveRequest

- (id)initFromDictionary:(NSDictionary *)dict{
    
    self = [super initFromDictionary:dict];
    
    if (self) {
        _removePair = [[ClassIDPair alloc] initFromDictionary:dict];
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    NSMutableDictionary *dict = [super toDictionary:isShell];
    
    dict[@"removePair"] = [_removePair toDictionary:isShell];
    
    return dict;
}

- (NSString*) remoteClassName{
	return [[self class]remoteClassName];
}

+ (NSString*) remoteClassName{
	return @"com.percero.agents.sync.vo.RemoveRequest";
}

- (NSString *) eventName {
    return @"removeObject";
}

@end
