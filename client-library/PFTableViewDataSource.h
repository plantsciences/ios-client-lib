//
//  PFTableViewDataSource.h
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PFTableViewDataSourceModeHeader,
    PFTableViewDataSourceModeCell,
} PFTableViewDataSourceMode;


@interface PFTableViewDataSource : NSObject <UITableViewDataSource>
@property (weak, nonatomic) id anchorObject;
@property (strong, nonatomic) NSString *keyPathForSectionsArray;
@property (strong, nonatomic) NSString *keyPathForCellsArray;
@property (strong, nonatomic) NSString *keyPathForSectionLabelText;
@property (strong, nonatomic) NSString *keyPathForCellLabelText;
@property (assign, nonatomic) PFTableViewDataSourceMode sectionMode;
@property (assign, nonatomic) BOOL canDeleteRows;

@property (strong, nonatomic) Class pfBindingTableViewCellSubclass;
- (id) tableView:(UITableView *)tableView dataObjectForRowAtIndexPath:(NSIndexPath *)indexPath;

+ (PFTableViewDataSource *)TableSectionDataWithAnchorObject:(id) anchorObject
                             pfBindingTableViewCellSubclass: (Class) pfBindingTableViewCellSubclass
                                    keyPathForSectionsArray:(NSString *) keyPathForSectionsArray
                                       keyPathForCellsArray:(NSString *) keyPathForCellsArray
                                 keyPathForSectionLabelText:(NSString *) keyPathForSectionLabelText
                                    keyPathForCellLabelText:(NSString *) keyPathForCellLabelText
                                                sectionMode:(PFTableViewDataSourceMode) sectionMode;
@end
