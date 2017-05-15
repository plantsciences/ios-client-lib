//
//  PushCWUpdateResponse.m
//
//  Created by Jeff Wolski.
//

#import "PushCWUpdateResponse.h"
#import "EntityManager.h"

@implementation PushCWUpdateResponse

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _classIDPair = [[ClassIDPair alloc] initFromDictionary:[dict objectForKey:@"classIdPair"]];
        _fieldName = [dict objectForKey:@"fieldName"];
        _params = [dict objectForKey:@"params"];
        _value = [dict objectForKey:@"value"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:[_classIDPair toDictionary:isShell]  forKey:@"classIDPair"];
        [dict setObject:_value forKey:@"value"];
        if (_params)[dict setObject:_params forKey:@"params"];
    }
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.PushCWUpdateResponse";
}


@end
