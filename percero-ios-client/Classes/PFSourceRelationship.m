//
//  PFSourceRelationship.m
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFSourceRelationship.h"

@implementation PFSourceRelationship

- (id)initBidirectionalWithPropertyName:(NSString *)propertyName
                       inverseClassName:(NSString *)inverseClassName
                    inversePropertyName:(NSString *)inversePropertyName
                             isRequired:(BOOL)isRequired
                           isCollection:(BOOL)isCollection{
    self = [super init];
    if (self) {
        super.isUnidirectional = NO;
        super.propertyName = propertyName;
        super.inverseClassName = inverseClassName;
        super.inversePropertyName = inversePropertyName;
        super.isRequired = isRequired;
        super.isCollection = isCollection;
    }
    return self;
}

- (id)initUnidirectionalWithPropertyName:(NSString *)propertyName
                        inverseClassName:(NSString *)inverseClassName
                              isRequired:(BOOL)isRequired
                            isCollection:(BOOL)isCollection{
    self = [super init];
    if (self) {
        super.isUnidirectional = YES;
        super.propertyName = propertyName;
        super.inverseClassName = inverseClassName;
        super.isRequired = isRequired;
        super.isCollection = isCollection;
    }
    return self;
}


- (NSString *)description{
    
    NSString *result = [super description];
    
    result = [NSString stringWithFormat:@"%@:%@%@ %@--> (%@ *) %@",result, self.isRequired?@"! ":@"  ", (self.propertyName)?self.propertyName:@"(?)", (self.isUnidirectional)?@"":@"<", self.inverseClassName, self.inversePropertyName];
    
    return result;
}
@end
