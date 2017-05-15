//
//  PFArraysBinder.m
//  Percero
//
//  Created by Jeff Wolski on 6/11/13.
//
//

#import "PFArraysBinder.h"
@interface PFModelObject (PFArrayBinder)

- (NSString *)arraysBinderChildrenKey ;
@end

@interface PFArraysBinder ()

@property (nonatomic, strong) NSMutableDictionary *children;

@end

@implementation PFArraysBinder

- (NSString *) keyPathLocal{
    NSString *result;
    if (self.keypaths && self.keypaths.count) {
        result = self.keypaths[0];
    }
    return result;
}
- (NSArray *) keyPathsNext{
    
    NSArray *result = nil;
    if (self.keypaths.count > 1) {
        NSMutableArray * newKeyPathsArray = [self.keypaths mutableCopy];
        [newKeyPathsArray removeObjectAtIndex:0];
        result = [newKeyPathsArray copy];
    }
   
    return result;
}
- (NSMutableDictionary *)children{
    if (!_children) {
        _children = [[NSMutableDictionary alloc] init];
    }
    return _children;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    DLog(@"\n\nchange:%@", change);
    if (self.delegate) {
        NSString *extendedKeypath = [NSString stringWithFormat:@"%@.%@",[self keyPathLocal], keyPath];

        [self.delegate observeValueForKeyPath:extendedKeypath ofObject:object change:change context:context];
    }
}


- (void) bindToArray{
    
    NSString *keyPath = [self keyPathLocal];
    
    if (keyPath) {
        [self.dataObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    
    
}
- (void) buildChildrenArray{
    NSArray *keypathsNext = [self keyPathsNext];
    if (keypathsNext && keypathsNext.count) {
        NSArray *dataArray = [self.dataObject valueForKeyPath:[self keyPathLocal]];
        for (PFModelObject *object in dataArray) {
            NSString *newChildKey = [object arraysBinderChildrenKey];
            PFArraysBinder *newArrayBinder = [[PFArraysBinder alloc] initWithDataObject:object keyPaths:keypathsNext];
            newArrayBinder.delegate = self;
            [self.children setObject:newArrayBinder forKey:newChildKey];
        }
    }
    
}

- (id)initWithDataObject:(PFModelObject *)dataObject keyPaths:(NSArray *)keypaths{
    if ([self init]){
        _dataObject = dataObject;
        _keypaths = keypaths;
        
        [self bindToArray];
        [self buildChildrenArray];
        
    }
    return self;
}


@end


@implementation PFModelObject (PFArraysBinder)

- (NSString *)arraysBinderChildrenKey{
    return  [NSString stringWithFormat:@"%@-%@",self.class,self.ID];
}


@end
