//
//  _Super_ServiceProvider.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_Super_ServiceProvider.h"

@implementation _Super_ServiceProvider
@synthesize ID, name, dateCreated, dateModified, isShell;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        ID = [dict valueForKey:@"id"];
        name = [dict valueForKey:@"name"];
        isShell = name?YES:NO;
        dateCreated = [dict valueForKey:@"dateCreated"];
        dateModified = [dict valueForKey:@"dateModified"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)shell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!shell){
        [dict setValue:name forKey:@"name"];
        [dict setValue:dateCreated forKey:@"dateCreated"];
        [dict setValue:dateModified forKey:@"dateModified"];
    }
    return dict;
}

- (void) overwriteWith:(id<PFModelObject>)object{
    if ([object isKindOfClass:[_Super_ServiceProvider class]]) {
        _Super_ServiceProvider* casted = (_Super_ServiceProvider*) object;
        
        name = casted.name;
        dateCreated = casted.dateCreated;
        dateModified = casted.dateModified;
        isShell = casted.isShell;
    }
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.ServiceProvider";
}


@end
