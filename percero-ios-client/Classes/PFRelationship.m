//
//  PFRelationship.m
//  
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFRelationship.h"

@implementation PFRelationship

- (NSString *)description {
    NSString *result;
    
    result = [NSString stringWithFormat:@"%@", self.class.description];
    
    return result;
}

@end
