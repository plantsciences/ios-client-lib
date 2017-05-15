//
//  PFInvocation.h
//  SocketConnect
//
//  Created by Jonathan Samples on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFInvocation : NSObject{
    NSObject* __target;
    SEL selector;
}

@property(nonatomic, weak) NSObject* target;
@property(nonatomic) SEL selector;

-(id) initWithTarget:(NSObject*)targetObject method:(SEL)selectorMethod;
-(void) invoke;
-(void) invokeWithArgument:(NSObject*) obj;

@end
