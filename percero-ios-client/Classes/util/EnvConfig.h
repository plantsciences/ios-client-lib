//
//  EnvConfig.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PFOAuthProviderTypeInvalid = 0,
    PFOauthProviderTypeGitHub,
    PFOauthProviderTypeGoogle
} PFOauthProviderType;

@interface EnvConfig : NSObject{
    NSDictionary* configs;

}
+ (NSString *) oauthProviderKeyForPFOauthProviderType:(PFOauthProviderType)pfOauthProviderType;
+ (NSDictionary *) oauthProviderDictForKey:(NSString *) key;

+ (EnvConfig*) sharedInstance;
- (NSString*) getEnvProperty:(NSString*) propName;
- (NSDictionary *) getEnvDictionary:(NSString *)keyPath;
-(NSArray *) oauthProviderKeys;

@end
