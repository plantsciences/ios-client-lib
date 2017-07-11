//
//  PFArraysBinder.h
//  Percero
//
//  Created by Jeff Wolski on 6/11/13.
//
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"

@protocol PFArraysBinderDelegate <NSObject>



@end

@interface PFArraysBinder : NSObject
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) PFModelObject *dataObject;
@property (nonatomic, strong) NSArray *keypaths;

- (id) initWithDataObject:(PFModelObject *) dataObject keyPaths:(NSArray *) keypaths;

@end
