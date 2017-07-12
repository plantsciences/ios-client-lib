//
//  GetRegAppOAuthsRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthRequest.h"

@interface GetRegAppOAuthsRequest : AuthRequest{
    NSString* regAppSecret;
    NSString* oauthType;
}

@property(nonatomic, retain) NSString* regAppSecret;
@property(nonatomic, retain) NSString* oauthType;

@end
