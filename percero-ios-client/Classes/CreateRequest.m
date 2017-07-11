//
//  CreateRequest.m
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//

#import "CreateRequest.h"

@implementation CreateRequest

- (id)initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if (self) {
        _theObject = dict[@"theObject"];
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    
    NSMutableDictionary *dict = [super toDictionary:isShell];
    
    if (dict) {
        dict[@"theObject"] = [_theObject toDictionary:isShell];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.CreateRequest";
}


- (NSString *) eventName {
    return @"createObject";
}

@end
