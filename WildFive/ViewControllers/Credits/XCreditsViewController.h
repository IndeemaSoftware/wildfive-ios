//
//  XCreditsViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"

@interface XCreditsViewController : XAbstractViewController  {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UIImageView *mBoardImageView;
    IBOutlet UILabel *mTitleLabel;
    IBOutlet UILabel *mOptigraLabel;
    IBOutlet UILabel *mAndreaLabel;
    IBOutlet UIButton *mOptigraButton;
    IBOutlet UIButton *mAndreaButton;
}

- (IBAction) optigraButton:(id)senderpSender;
- (IBAction) andreaButton:(id)senderpSender;

@end
