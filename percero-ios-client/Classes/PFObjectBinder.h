//
//  PFObjectBinder.h
//  iOS Mobile Companion
//
//  Created by Jeff Wolski on 4/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFObjectBinder : NSObject

@property (weak, nonatomic) id targetObject;
@property (strong, nonatomic) NSString *targetKeyPath;
@property (weak, nonatomic) id sourceObject;
@property (strong, nonatomic) NSString *sourceKeyPath;


- (PFObjectBinder *)initWithTargetObject:(id) targetObject targetKeyPath:(NSString *) targetKeyPath sourceObject:(id) sourceObject sourceKeyPath:(NSString *) sourceKeyPath;
- (void) resetWithTargetObject:(id) targetObject targetKeyPath:(NSString *) targetKeyPath sourceObject:(id) sourceObject sourceKeyPath:(NSString *) sourceKeyPath;
- (void)unregisterKvo;

@end
