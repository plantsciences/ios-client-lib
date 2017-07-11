//
//  PFSourceRelationship.h
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFRelationship.h"

@interface PFSourceRelationship : PFRelationship

- initUnidirectionalWithPropertyName:(NSString *) propertyName
                    inverseClassName:(NSString *) inverseClassName
                          isRequired:(BOOL)isRequired
                        isCollection:(BOOL) isCollection;
- initBidirectionalWithPropertyName:(NSString *) propertyName
                   inverseClassName:(NSString *) inverseClassName
                inversePropertyName:(NSString *) inversePropertyName
                         isRequired:(BOOL)isRequired
                       isCollection:(BOOL) isCollection;



@end
