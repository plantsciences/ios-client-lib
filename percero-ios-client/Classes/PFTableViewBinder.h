//
//  PFTableViewBinder.h
//  Percero
//
//  Created by Jeff Wolski on 5/13/13.
//
//

#import <Foundation/Foundation.h>
#import "PFTableViewDataSource.h"

@interface PFTableViewBinder : NSObject
@property (weak, nonatomic) id anchorObject;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *keyPathForSectionsArray;
@property (strong, nonatomic) NSString *keyPathForCellsArray;
@property (strong, nonatomic) NSString *keyPathForSectionLabelText;
@property (strong, nonatomic) NSString *keyPathForCellLabelText;
@property (assign, nonatomic) PFTableViewDataSourceMode sectionMode;
@property (nonatomic, strong) PFTableViewDataSource *dataSource;

@property (strong, nonatomic) Class pfBindingTableViewCellSubclass;
- (void) registerKVO;
-(void) unregisterKVO;
+ (PFTableViewBinder *)TableSectionDataWithAnchorObject:(id)anchorObject
                                              tableView:(UITableView *) tableView pfBindingTableViewCellSubclass:(Class)pfBindingTableViewCellSubclass keyPathForSectionsArray:(NSString *)keyPathForSectionsArray keyPathForCellsArray:(NSString *)keyPathForCellsArray keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText keyPathForCellLabelText:(NSString *)keyPathForCellLabelText sectionMode:(PFTableViewDataSourceMode)sectionMode;

@end
