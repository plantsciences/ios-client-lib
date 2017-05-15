//
//  PFBindingTableViewCell.m
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import "PFBindingTableViewCell.h"

@implementation PFBindingTableViewCell

//- (void)setDataObject:(id)dataObject{
////    _anchorObjectBinder = nil;
//    _dataObject = dataObject;
//    NSString *labelKeyPath = @"textLabel.text";
//    NSString *sourceKeypath = [NSString stringWithFormat:@"dataObject.%@", _keyPathForDataObjectLabelString];
//
////    _anchorObjectBinder = [[PFObjectBinder alloc] initWithTargetObject:self targetKeyPath:labelKeyPath sourceObject:self sourceKeyPath:sourceKeypath];
//}

- (PFObjectBinder *)anchorObjectBinder{
    if (!_anchorObjectBinder) {
            _anchorObjectBinder = [[PFObjectBinder alloc] init];
        
    }
    return _anchorObjectBinder;
}
- (NSMutableSet *)binders{
    
    if (!_binders) {
        _binders = [[NSMutableSet alloc] init];
    }
    return _binders;
}

- (id)initWithDataObject:(id)dataObject{
    if ([self isMemberOfClass:[PFBindingTableViewCell class]]) {
        
        if (self = [self init]) {
            _dataObject = dataObject;
        }
    } else {
        if (self = [super init]) {
            _dataObject = dataObject;
        }
    }
    return  self;
}

- (id)initWithkeyPathForAnchorObjectLabelString:(NSString *)keyPathForAnchorObjectLabelString{

    if ([self isMemberOfClass:[PFBindingTableViewCell class]]) {
        _keyPathForDataObjectLabelString = keyPathForAnchorObjectLabelString;
        if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class]description]]) {
            NSString *labelKeyPath = @"textLabel.text";
            
            NSString *sourceKeypath = [NSString stringWithFormat:@"dataObject.%@", _keyPathForDataObjectLabelString];
            
            _anchorObjectBinder = [[PFObjectBinder alloc] initWithTargetObject:self targetKeyPath:labelKeyPath sourceObject:self sourceKeyPath:sourceKeypath];
        }
        
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        
        for (PFObjectBinder *binder in self.binders) {
            [binder unregisterKvo];
        }
        
    } else {
        NSString *labelKeyPath = @"textLabel.text";
        NSString *sourceKeypath = [NSString stringWithFormat:@"dataObject.%@", _keyPathForDataObjectLabelString];
        
        [_anchorObjectBinder resetWithTargetObject:self targetKeyPath:labelKeyPath sourceObject:self sourceKeyPath:sourceKeypath];

    }
}

- (void)dealloc{
    DLog(@"self.anchorObjectBinder:%@",self.anchorObjectBinder);
    [_binders removeAllObjects];
    DLog(@"%@ will unregisterKVO", self.class);
    [self.anchorObjectBinder unregisterKvo];
    DLog(@"%@ did unregisterKVO", self.class);

    
}

@end
