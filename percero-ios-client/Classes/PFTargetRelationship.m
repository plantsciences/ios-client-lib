//
//  PFTargetRelationship.m
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFTargetRelationship.h"

@implementation PFTargetRelationship


- (id)initUnidirectionalWithInverseClassName:(NSString *)inverseClassName inversePropertyName:(NSString *)inversePropertyName isRequired:(BOOL)isRequired isCollection:(BOOL)isCollection{
    self = [super init];
    if (self) {
        super.isUnidirectional = YES;
        super.inverseClassName = inverseClassName;
        super.inversePropertyName = inversePropertyName;
        super.isCollection = isCollection;
        super.isRequired = isRequired;
    }
    return self;
}

- (id)initBidirectionalWithPropertyName:(NSString *)propertyName inverseClassName:(NSString *)inverseClassName inversePropertyName:(NSString *)inversePropertyName isRequired:(BOOL)isRequired isCollection:(BOOL)isCollection{
    self = [super init];
    if (self) {
        
        super.isUnidirectional = NO;
        super.propertyName = propertyName;
        super.inverseClassName = inverseClassName;
        super.inversePropertyName = inversePropertyName;
        super.isCollection = isCollection;
        super.isRequired = isRequired;

    }
    return self;

}

- (NSString *)description{
    
    NSString *result = [super description];
    
    result = [NSString stringWithFormat:@"%@:%@%@ <--%@ (%@ *) %@",result, self.isRequired?@"! ":@"  ", (self.propertyName)?self.propertyName:@"(?)", (self.isUnidirectional)?@"":@">", self.inverseClassName, self.inversePropertyName];
    
    return result;
}
@end
