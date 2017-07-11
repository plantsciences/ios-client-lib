//
//  PFBindingTableViewCell.h
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import <UIKit/UIKit.h>
#import "PFObjectBinder.h"
@interface PFBindingTableViewCell : UITableViewCell
@property (nonatomic, weak) id dataObject;
@property (nonatomic, strong) NSString *keyPathForDataObjectLabelString;
@property (nonatomic, strong) NSMutableSet *binders;
@property (nonatomic, strong) PFObjectBinder *anchorObjectBinder;
- (id) initWithkeyPathForAnchorObjectLabelString:(NSString *) keyPathForAnchorObjectLabelString;
- (id) initWithDataObject:(id) dataObject;
@end
