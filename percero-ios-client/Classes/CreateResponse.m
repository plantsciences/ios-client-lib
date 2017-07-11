//
//  CreateResponse.m
//  Percero
//
//  Created by Jeff Wolski on 3/26/13.
//
//

#import "CreateResponse.h"
#import "EntityManager.h"

@implementation CreateResponse

- (id)initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if (self) {
        
        _theObject = [[EntityManager sharedInstance] deserializeObject:dict[@"theObject"] ];
        
        _result = [dict[@"result"] boolValue];
        
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    NSMutableDictionary *dict = [super toDictionary:isShell];
    
    dict[@"result"] = @(_result);
    
    dict[@"theObject"] = [_theObject toDictionary:isShell];
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.CreateResponse";
}
@end
