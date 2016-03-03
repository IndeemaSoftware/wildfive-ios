//
//  XOfflineGameLevelViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"

@interface XOfflineGameLevelViewController : XAbstractViewController  {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UIImageView *mBoardImageView;
    IBOutlet UIButton *mEasyButton;
    IBOutlet UIButton *mMediumButton;
    IBOutlet UIButton *mHardButton;
    IBOutlet UIButton *mPlayerButton;
}

- (IBAction)levelSlected:(id)pSender;
@end
