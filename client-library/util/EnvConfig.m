//
//  EnvConfig.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvConfig.h"

static EnvConfig* sharedInstance;
@implementation EnvConfig

+ (EnvConfig*) sharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[EnvConfig alloc] init];
    }
    
    return sharedInstance;
}

/**
 * function getEnvProperty
 *
 * Will return an NSString for the value associated with the propName that is passed in.  If no property is
 * found to match the propName then nil will be returned.
 *
 * @param - NSString* propName -    The name of the property to be retrived from the properties file
 *                                  this can take the form of either 'name' or something like 'env.giggle.name'.
 *                                  Using the '.' syntax can be used as just part of the property name or 
 *                                  can dig deeper into the properties file if it is organized with dictionaries.
 */
- (NSString*) getEnvProperty:(NSString *)propName{
    id prop = [configs valueForKey:propName];
    // First check to see if the whole propname was used as the key... next try and break it up and dive deep
    if(!prop){
        NSArray* foo = [propName componentsSeparatedByString: @"."];
        NSDictionary* currentDict = configs;
        for (NSString* segment in foo) {
            prop = [currentDict valueForKey:segment];
            if(prop && [prop isKindOfClass:[NSDictionary class]]){
                currentDict = prop;
            }
            else if(!prop){
                break;
            }
        }
    }
    
    return prop;
}

-(id) init{
    self  = [super init]; 
    if(self){
        NSString* configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
        NSBundle* bundle = [NSBundle mainBundle];
        NSString* envsPListPath = [bundle pathForResource:@
                                   "env" ofType:@"plist"];
        NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
        configs = [environments objectForKey:configuration];
    }
    
    return self;
}

- (NSString*) stringForKey:(NSString*) key inDict:(NSDictionary*)dict{
    NSString* result = @"";
    for(NSString* subKey in dict){
        id value = [dict valueForKey:subKey];
        
        // If the value is a String then we don't recurse further
        if([value isKindOfClass:[NSString class]]){
            if([key length] != 0){
                result = [NSString stringWithFormat:@"%@%@.%@: %@\n", result, key, subKey, value];
            }
            else{
                result = [NSString stringWithFormat:@"%@%@: %@\n", result, subKey, value];
            }
        }
        // If it is a dictionary, we need to keep recursing
        else if([value isKindOfClass:[NSDictionary class]]){
            NSString* newKey;
            if(key.length == 0){
                newKey = subKey;
            }
            else{
                newKey = [NSString stringWithFormat:@"%@.%@", key, subKey];
            }
            
            NSString* recursiveResult = [self stringForKey:newKey inDict:value];
            result = [NSString stringWithFormat:@"%@%@", result, recursiveResult];
        }
    }
    
    return result;
}

- (NSString*) description{
    return [self stringForKey:@"" inDict:configs];
}

@end
