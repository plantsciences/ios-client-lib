//
//  PFTableViewDataSource.m
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import "PFTableViewDataSource.h"
#import "PFBindingTableViewCell.h"
#import "PFModelObject.h"
#import "PFArraysBinder.h"

@interface PFTableViewDataSource ()



@end


@implementation PFTableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.canDeleteRows;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        PFModelObject *cellObject = [self tableView:tableView dataObjectForRowAtIndexPath:indexPath];
        [cellObject delete];
    }
}

- (id) tableView:(UITableView *)tableView dataObjectForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rowsArray = [self tableView:tableView dataObjectsArrayForSection:indexPath.section];
    NSInteger offset = (PFTableViewDataSourceModeCell == self.sectionMode)?1:0;

    id cellObject;
    if ((PFTableViewDataSourceModeCell == self.sectionMode) && (indexPath.row == 0)) {
        NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
        cellObject = sectionsArray[indexPath.section];
    } else {
        cellObject = rowsArray[indexPath.row - offset];
    }
    return cellObject;
}

- (NSArray *) tableView:(UITableView *)tableView dataObjectsArrayForSection:(NSInteger)section{
    NSArray *cellsArray;
    
    if (_keyPathForSectionsArray) {
        NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
        id sectionObject = sectionsArray[section];
        cellsArray = [sectionObject valueForKeyPath:_keyPathForCellsArray];
        
    } else {
        cellsArray = [_anchorObject valueForKeyPath:_keyPathForCellsArray];
    }
    return cellsArray;
}

- (void)setPfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass{
    if ([pfBindingTableViewCellSubclass isSubclassOfClass:[PFBindingTableViewCell class]]) {
        _pfBindingTableViewCellSubclass = pfBindingTableViewCellSubclass;
    } else {
        [NSException exceptionWithName:@"PFTableViewDataSource" reason:@"pfBindingTableViewCellSubclass myst be a subclass of PFBindingTableViewCell" userInfo:@{@"pfBindingTableViewCellSubclass":pfBindingTableViewCellSubclass}];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    id cellObject = [self tableView:tableView dataObjectForRowAtIndexPath:indexPath];

    PFBindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[_pfBindingTableViewCellSubclass class]description]];
    if (!cell) {
        if (self.pfBindingTableViewCellSubclass == [PFBindingTableViewCell class]) {
            cell = [[_pfBindingTableViewCellSubclass alloc] initWithkeyPathForAnchorObjectLabelString:self.keyPathForCellLabelText];

        } else {
            cell = [[_pfBindingTableViewCellSubclass alloc] initWithDataObject:cellObject];
        }
        
        //if (!cell.textLabel.text) cell.textLabel.text = @".";
        
    } else {
        DLog(@"cell was already queued");
    }
    
    cell.dataObject = cellObject;
    
    if (!cell) {
        DLog(@"cell is null");
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!self.keyPathForSectionsArray || (self.sectionMode == PFTableViewDataSourceModeCell)) {
        return nil;
    }
    
    NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
    id sectionObject = sectionsArray[section];
    NSString *sectionTitle = [sectionObject valueForKeyPath:_keyPathForSectionLabelText];
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger offset = (PFTableViewDataSourceModeCell == self.sectionMode)?1:0;
    NSArray *cellsArray;
    
    cellsArray = [self tableView:tableView dataObjectsArrayForSection:section];

    NSInteger numberOfCells = cellsArray.count + offset;
    
    return numberOfCells;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberOfSections = 1;
    if (_keyPathForSectionsArray) {
        NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
        numberOfSections = sectionsArray.count;

    }
    return numberOfSections;
}
#pragma mark

- (id)init{
    if (self = [super init]);{

    }
    return self;
}

- (id) initWithAnchorObject:(id)anchorObject
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
        _keyPathForSectionsArray = keyPathForSectionsArray;
        _keyPathForCellsArray = keyPathForCellsArray;
        _keyPathForSectionLabelText = keyPathForSectionLabelText;
        _keyPathForCellLabelText = keyPathForCellLabelText;
        _sectionMode = sectionMode;
        
    }
    
    return self;
}

+ (PFTableViewDataSource *)TableSectionDataWithAnchorObject:(id)anchorObject pfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass keyPathForSectionsArray:(NSString *)keyPathForSectionsArray keyPathForCellsArray:(NSString *)keyPathForCellsArray keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText keyPathForCellLabelText:(NSString *)keyPathForCellLabelText sectionMode:(PFTableViewDataSourceMode)sectionMode {
    
    PFTableViewDataSource *result = [[PFTableViewDataSource alloc] initWithAnchorObject:anchorObject pfBindingTableViewCellSubclass:pfBindingTableViewCellSubclass keyPathForSectionsArray:keyPathForSectionsArray keyPathForCellsArray:keyPathForCellsArray keyPathForSectionLabelText:keyPathForSectionLabelText keyPathForCellLabelText:keyPathForCellLabelText sectionMode:sectionMode];
    return result;
}

- (void)setAnchorObject:(id)anchorObject{
    _anchorObject = anchorObject;
    
}
@end
