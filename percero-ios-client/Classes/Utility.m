//
//  Utility.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

@implementation Utility

/**
 * Take a full package classname and return it's equivalent name for Obj-C
 * (It really just hacks off everything except the last part)
 */
+ (NSString*) translateRemoteClassName:(NSString *)name
{
    NSArray* foo = [name componentsSeparatedByString: @"."];
    return [foo objectAtIndex:[foo count]-1];
}

@end
