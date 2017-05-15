//
//  PFTableViewBinder.m
//  Percero
//
//  Created by Jeff Wolski on 5/13/13.
//
//

#import "PFTableViewBinder.h"
#import "PFBindingTableViewCell.h"
#import "PFArraysBinder.h"

@interface PFTableViewBinder (){
    BOOL isRegistered;
}
//@property (nonatomic, strong) NSMutableArray *rowBindings;
@property (nonatomic, strong) PFArraysBinder *arraysBinder;
@end

@implementation PFTableViewBinder

- (void)insertRowsForChange:(NSDictionary *)change {
    NSMutableArray * paths = [NSMutableArray array];
    NSIndexSet *indexes = [change valueForKey:NSKeyValueChangeIndexesKey];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        NSUInteger sectionAndRow[2] = {0, index};
        [paths addObject:[NSIndexPath indexPathWithIndexes:sectionAndRow
                                                    length:2]];
    }];
    [self.tableView insertRowsAtIndexPaths:paths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeRowsForChange:(NSDictionary *)change {
    NSMutableArray * paths = [NSMutableArray array];
    NSIndexSet *indexes = [change valueForKey:NSKeyValueChangeIndexesKey];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        NSUInteger sectionAndRow[2] = {0, index};
        [paths addObject:[NSIndexPath indexPathWithIndexes:sectionAndRow length:2]];
    }];
    [self.tableView deleteRowsAtIndexPaths:paths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    DLog(@"%@",change);
    NSInteger kind = [change[NSKeyValueChangeKindKey] intValue];

    switch (kind) {
        case NSKeyValueChangeInsertion:
            [self insertRowsForChange:change];
            break;
          
        case NSKeyValueChangeRemoval:
            [self removeRowsForChange:change];
            break;
            
        default:
            DLog(@"Unknown Table KVO");
            [self.tableView reloadData];
            break;
    }
    
//    NSArray *newObjects = [change valueForKey:NSKeyValueChangeNewKey];
//    if (kind == NSKeyValueChangeInsertion) {
//        [self insertRowsForChange:change];        
//    } else {
//        [self.tableView reloadData];
//    }
}

- (id) initWithAnchorObject:(id)anchorObject
tableView:(UITableView *) tableView
pfBindingTableViewCellSubclass: (Class) pfBindingTableViewCellSubclass
    keyPathForSectionsArray:(NSString *)keyPathForSectionsArray
       keyPathForCellsArray:(NSString *)keyPathForCellsArray
 keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText
    keyPathForCellLabelText:(NSString *)keyPathForCellLabelText
                sectionMode:(PFTableViewDataSourceMode)sectionMode{
    if (self = [self init]) {
        _anchorObject = anchorObject;
        _pfBindingTableViewCellSubclass = pfBindingTableViewCellSubclass;
        if (!_pfBindingTableViewCellSubclass){ _pfBindingTableViewCellSubclass = [PFBindingTableViewCell class];
        }
        _tableView = tableView;
        _keyPathForSectionsArray = keyPathForSectionsArray;
        _keyPathForCellsArray = keyPathForCellsArray;
        _keyPathForSectionLabelText = keyPathForSectionLabelText;
        _keyPathForCellLabelText = keyPathForCellLabelText;
        _sectionMode = sectionMode;
        
        _dataSource = [PFTableViewDataSource TableSectionDataWithAnchorObject:(id)anchorObject pfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass keyPathForSectionsArray:(NSString *)keyPathForSectionsArray keyPathForCellsArray:(NSString *)keyPathForCellsArray keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText keyPathForCellLabelText:(NSString *)keyPathForCellLabelText sectionMode:(PFTableViewDataSourceMode)sectionMode ];
        _tableView.dataSource = _dataSource;
        [self registerKVO];
    }
    
    return self;
}
- (NSArray *) keyPathsArray {
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:2];
    if (self.keyPathForSectionsArray) {
        [result addObject:self.keyPathForSectionsArray];
    }
    if (self.keyPathForCellsArray) {
        [result addObject:self.keyPathForCellsArray];
    }
    return result;
}
- (void)registerKVO{
    self.arraysBinder = [[PFArraysBinder alloc] initWithDataObject:self.anchorObject keyPaths:[self keyPathsArray]];
    self.arraysBinder.delegate = self;
//    if (!isRegistered) {
//        NSString *keyPath = [NSString stringWithFormat:@"anchorObject.%@",self.keyPathForCellsArray];
//        [self addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:NULL];
//        DLog(@"register:%@.%@",self,keyPath);
//        
//        isRegistered = YES;
//    }
}
- (void)unregisterKVO{
//    if (isRegistered) {
//        NSString *keyPath = [NSString stringWithFormat:@"anchorObject.%@",self.keyPathForCellsArray];
//
//        [self removeObserver:self forKeyPath:keyPath];
//        DLog(@"unregister:%@.%@",self,keyPath);
//        isRegistered = NO;
//    }
}
+ (PFTableViewBinder *)TableSectionDataWithAnchorObject:(id)anchorObject
                         tableView:(UITableView *) tableView
                         pfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass keyPathForSectionsArray:(NSString *)keyPathForSectionsArray keyPathForCellsArray:(NSString *)keyPathForCellsArray keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText keyPathForCellLabelText:(NSString *)keyPathForCellLabelText sectionMode:(PFTableViewDataSourceMode)sectionMode {
    
    PFTableViewBinder *result = [[PFTableViewBinder alloc] initWithAnchorObject:anchorObject
                                                 tableView:(UITableView *) tableView
                                                 pfBindingTableViewCellSubclass:pfBindingTableViewCellSubclass keyPathForSectionsArray:keyPathForSectionsArray keyPathForCellsArray:keyPathForCellsArray keyPathForSectionLabelText:keyPathForSectionLabelText keyPathForCellLabelText:keyPathForCellLabelText sectionMode:sectionMode];
    return result;
}
- (void)dealloc{
    [self unregisterKVO];
}
@end
