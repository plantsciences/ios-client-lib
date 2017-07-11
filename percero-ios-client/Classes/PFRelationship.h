//
//  PFRelationship.h
//  
//
//  Created by Jeff Wolski on 3/20/13.
//
//


@interface PFRelationship : NSObject

@property (nonatomic, copy) NSString *propertyName;
@property (nonatomic, copy) NSString *inverseClassName;
@property (nonatomic, copy) NSString *inversePropertyName;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, assign) BOOL isRequired;
@property (nonatomic, assign) BOOL isUnidirectional;

/*
 SU ->  propertyName inverseClassName
 SB ->  propertyName inverseClassName  inversePropertyName
 TU ->               inverseClassName  inversePropertyName
 TB ->  propertyName inverseClassName  inversePropertyName
 */

@end
