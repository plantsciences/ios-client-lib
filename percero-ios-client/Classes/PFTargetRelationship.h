//
//  PFTargetRelationship.h
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import <Foundation/Foundation.h>

#import "PFRelationship.h"

@interface PFTargetRelationship : PFRelationship


- initUnidirectionalWithInverseClassName:(NSString *) inverseClassName
                     inversePropertyName:(NSString *) inversePropertyName
                              isRequired:(BOOL) isRequired
                            isCollection:(BOOL) isCollection;

- initBidirectionalWithPropertyName:(NSString *) propertyName
                   inverseClassName:(NSString *) inverseClassName
                inversePropertyName:(NSString *) inversePropertyName
                         isRequired:(BOOL) isRequired
                       isCollection:(BOOL) isCollection;


@end
