//
//  PFInvocation.m
//  SocketConnect
//
//  Created by Jonathan Samples on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFInvocation.h"

@implementation PFInvocation
@synthesize target, selector;

-(id) init{
    self = [super init];
    
    return self;
}

-(id) initWithTarget:(NSObject*)targetObject method:(SEL)selectorMethod{
    self = [self init];
    if(self){
        target = targetObject;
        selector = selectorMethod;
    }
    
    return self;
}


-(void) invoke{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:selector];
#pragma clang diagnostic pop

}

-(void) invokeWithArgument:(NSObject*) obj{
//     NSLog (@"\nJGC target = %@ selector = %@ obj = %@",target,NSStringFromSelector(selector),obj);
//    if ([NSStringFromSelector(selector) isEqualToString:@"trimQualityTotalInvUnitsPackedCallback:"]) {
//        NSLog (@"JGC");
//    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:selector withObject:obj];
#pragma clang diagnostic pop
    
//    DLog(@"[target performSelector:selector withObject:obj] where: obj.description=%@ target.description=%@",obj.description,target.description);
}

@end
