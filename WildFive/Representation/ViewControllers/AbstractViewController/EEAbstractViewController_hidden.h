//
//  EEAbstractViewController_EEAbstractViewControllerHidden.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/5/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEAbstractViewController.h"

@interface EEAbstractViewController () <UIActionSheetDelegate> {
    UIButton *mBackButton;
    UIButton *mRightButton;
    UIButton *mHintButton;
}

- (UIButton*)backBatton;
- (UIButton*)hintButton;
- (UIButton*)rightButton;

- (void)localizeUIElements;

@end
