//
//  PutResponse.m
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "PutResponse.h"
#import "EntityManager.h"

@implementation PutResponse

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _result = [[dict objectForKey:@"result"] boolValue];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:@(_result) forKey:@"result"];
    }
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.PutResponse";
}


@end
