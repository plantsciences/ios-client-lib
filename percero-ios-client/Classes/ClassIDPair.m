//
//  ClassIDPair.m
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "ClassIDPair.h"

@implementation ClassIDPair

- (id)initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if (self) {
        
        self.ID = dict[@"ID"];
        self.className = dict[@"className"];
        if (!self.className) {
            self.className = dict[@"cn"];
        }
        self.properties = dict[@"properties"];
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)shell{
    
    NSMutableDictionary *dict = [super toDictionary:shell];
    
    // Always set the ID and classname
	dict[@"ID"] = ID;
    if (_properties) dict[@"properties"] = _properties;
//	if(!isShell){
//		// If we're not sending a shell then...
//		dict[@"cn"] = [self remoteClassName];
//        
//        
//    } else {
    
        dict[@"className"] = [self remoteClassName];

        
//    }
    
    return dict;
}

- (NSString *)remoteClassName{
    return self.className;
}


@end
