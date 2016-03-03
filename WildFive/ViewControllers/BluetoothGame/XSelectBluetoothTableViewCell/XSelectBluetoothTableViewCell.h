//
//  XSelectBluetoothTableViewCell.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSelectBluetoothTableViewCell : UITableViewCell {
    IBOutlet UILabel *mTitleLabel;
    IBOutlet UIImageView *mBackgroundView;
}

- (void) setHiddenBackground:(BOOL)pIsHidden;

@end
