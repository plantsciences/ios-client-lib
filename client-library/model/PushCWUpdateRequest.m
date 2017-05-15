//
//  PushCWUpdateRequest.m
//
//  Created by Jeff Wolski.
//


#import "PushCWUpdateRequest.h"

@implementation PushCWUpdateRequest

- (id) init{
    self = [super init];
    if(self){
        DLog(@"");
        _classIDPair = [[ClassIDPair alloc] init];
        _fieldName = nil;
        _params = nil;
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _classIDPair = [[ClassIDPair alloc]initFromDictionary:[dict objectForKey:@"classIdPair"]];

        _fieldName = [dict objectForKey:@"fieldName"];
        _params = [dict objectForKey:@"params"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:[_classIDPair toDictionary:isShell]  forKey:@"classIdPair"];

        [dict setObject:_fieldName forKey:@"fieldName"];
        if (_params)[dict setObject:_params forKey:@"params"];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.PushCWUpdateRequest";
}

- (NSString *) eventName {
    return @"pushCWUpdate";
}


@end
