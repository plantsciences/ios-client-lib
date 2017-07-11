//
//  Serializable.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Serializable <NSObject>

- (id) initFromDictionary:(NSDictionary*) dict;
- (NSMutableDictionary*) toDictionary:(BOOL)isShell;
- (NSString*) remoteClassName;

@end
