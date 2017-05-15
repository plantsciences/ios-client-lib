//
//  PutRequest.m
//  Percero
//
//  Created by Jeff Wolski on 3/14/13.
//
//

#import "PutRequest.h"

@implementation PutRequest

- (id) init{
    self = [super init];
    if(self){
        DLog(@"");
        _theObject = nil;
        _putTimestamp = 0;
        _transId = nil;
        
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
   
        _theObject = dict[@"theObject"];
        _putTimestamp = [dict[@"putTimestamp"] longValue];
        _transId = dict[@"transId"];
        
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    dict[@"cn"] = self.remoteClassName;
    if(!isShell){
        
        dict[@"theObject"] = [_theObject toDictionary:NO];
        dict[@"putTimestamp"] = @(_putTimestamp);
        dict[@"transId"] = _transId;
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.PutRequest";
}

- (NSString *) eventName {
    return @"putObject";
}


@end
