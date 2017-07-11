//
//  FindByExampleResponse.m
//  Percero
//
//  Created by Jeff Wolski on 4/22/13.
//
//

#import "FindByExampleResponse.h"
#import "EntityManager.h"

@implementation FindByExampleResponse

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _result = [[EntityManager sharedInstance] deserializeObject:[dict objectForKey:@"result"]]; ;
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:_result forKey:@"result"];
    }
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.FindByExampleResponse";
}


@end
