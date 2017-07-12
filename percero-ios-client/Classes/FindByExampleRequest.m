//
//  FindByExampleRequest.m
//  Percero
//
//  Created by Jeff Wolski on 4/22/13.
//
//

#import "FindByExampleRequest.h"

@implementation FindByExampleRequest

- (id) init{
    self = [super init];
    if(self){
        _theObject = nil;
    }
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _theObject =  [dict objectForKey:@"theObject"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:isShell];
    
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:[_theObject toDictionary:NO] forKey:@"theObject"];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.FindByExampleRequest";
}

- (NSString *) eventName {
    return @"findByExample";
}


@end
