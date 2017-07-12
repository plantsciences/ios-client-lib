//
//  GetRegAppOAuthsResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthResponse.h"

@interface GetRegAppOAuthsResponse : AuthResponse{
    NSMutableArray* result;
}

@property(nonatomic, retain) NSMutableArray* result;

@end
