//
//  SSDC_Response.h
//  Percero
//
//  Created by John Coumerilh on 12/5/14.
//
//

#import <Percero/Percero.h>

@interface SSDC_Response : NSObject
@property(nonatomic, retain) ClassIDPair* classIDPair;
@property(nonatomic, retain) NSString* fieldName;
@property(nonatomic, retain) NSArray* params;
@property(nonatomic, retain) id value;
@end
