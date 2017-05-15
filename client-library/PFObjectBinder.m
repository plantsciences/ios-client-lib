//
//  PFObjectBinder.m
//  iOS Mobile Companion
//
//  Created by Jeff Wolski on 4/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import "PFObjectBinder.h"
#import "PFModelObject.h"
#import "PFBindingTableViewCell.h"

@interface PFObjectBinder (){
    BOOL registered;
}
@end


@implementation PFObjectBinder

- (NSString *)sourceKeyPath{
    NSString *result = [NSString stringWithFormat:@"sourceObject.%@", _sourceKeyPath];
    return result;
}

- (void) updateTargetObject{
    DLog(@"updateTarget sourceClass:%@  targetClass:%@",[_sourceObject class], [_targetObject class]);
    if (_sourceObject && _sourceKeyPath && _targetObject && _targetKeyPath) {
        
        id sourceValue = [self valueForKeyPath:self.sourceKeyPath];
        [self.targetObject setValue:sourceValue forKeyPath:self.targetKeyPath];
        
    }
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    DLog(@"");
    if (registered) {
        if ([keyPath isEqualToString:@"targetObject"]) {
            if (!self.targetObject) {
                [self unregisterKvo];
            }
        } else {
            [self updateTargetObject];
        }
    }
    
}
//- (void)setTargetObject:(id)targetObject{
//    
//    [self unregisterKvo];
//    _targetObject = targetObject;
//    [self registerKvo];
//    
//}
//
//- (void)setTargetKeyPath:(NSString *)targetKeyPath{
//    
//    [self unregisterKvo];
//    _targetKeyPath = targetKeyPath;
//    [self registerKvo];
//    
//}
//
//- (void)setSourceObject:(id)sourceObject{
//    
//    [self unregisterKvo];
//    _sourceObject = sourceObject;
//    [self registerKvo];
//    
//}
//
//- (void)setSourceKeyPath:(NSString *)sourceKeyPath{
//    
//    [self unregisterKvo];
//    _sourceKeyPath = sourceKeyPath;
//    [self registerKvo];
//    
//}

- (void)resetWithTargetObject:(id)targetObject targetKeyPath:(NSString *)targetKeyPath sourceObject:(id)sourceObject sourceKeyPath:(NSString *)sourceKeyPath{
    
    [self unregisterKvo];
    
    _targetObject = targetObject;
    _targetKeyPath = targetKeyPath;
    _sourceObject = sourceObject;
    _sourceKeyPath = sourceKeyPath;
    
    
    [self registerKvo];
}
//- (void) registerForTarget{
//    // We register for the target to react when it deallocates
//    DLog(@"");
//    [self addObserver:self forKeyPath:@"targetObject" options:NSKeyValueObservingOptionPrior context:NULL];
//    
//}

- (PFObjectBinder *)initWithTargetObject:(id)targetObject targetKeyPath:(NSString *)targetKeyPath sourceObject:(id)sourceObject sourceKeyPath:(NSString *)sourceKeyPath{
    
    if (self = [self init]) {
        
        _targetObject = targetObject;
        _targetKeyPath = targetKeyPath;
        _sourceObject = sourceObject;
        _sourceKeyPath = sourceKeyPath;

        [self registerKvo];

    }
   
    return self;
}

- (void) addBinderToParentSet {
    if ([self.sourceObject isKindOfClass:[PFBindingTableViewCell class]]) {
        
        [((PFBindingTableViewCell *)self.sourceObject).binders addObject:self];
    }
}

- (void) registerKvo{
    if (!registered) {
        if ( _sourceKeyPath) {
            if ([_sourceObject respondsToSelector:@selector(isSubclassOfClass:)]) {
                if ([_sourceObject isSubclassOfClass:[PFModelObject class]]) {
                    // source object is a PFModelObject subclass
                    NSString *notificationName = [NSString stringWithFormat:@"modelDidChange%@",[[_sourceObject class] description]];
                    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                    [nc addObserver:self selector:@selector(updateTargetObject) name:notificationName object:nil];
                    
                } else {
                    //
                }
            } else {
                // source object is an instance
                DLog(@"register sourceObject class:%@  targetObjectClass:%@", [self.sourceObject class], [self.targetObject class]);
                [self addObserver:self forKeyPath:self.sourceKeyPath options:0 context:nil];
                registered = YES;

            }
        }
//            [self registerForTarget];
        
        [self addBinderToParentSet];
        
        [self updateTargetObject];
    }
    
    
}

- (void)unregisterKvo{
    
    if (registered) {

        //    [self removeObserver:self forKeyPath:@"targetObject"];
        
        if ( _sourceKeyPath) {
            DLog(@"unregister")
            [self removeObserver:self forKeyPath:self.sourceKeyPath];
            registered = NO;
        } else {
            DLog(@"fail unregister _sourceObject:%@ _sourceKeypath:%@", _sourceObject, _sourceKeyPath);
        }

    }
    
}

- (void)dealloc{
    DLog(@"");

    [self unregisterKvo];
}

@end
