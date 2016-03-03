//
//  XSettingsViewController.h
//  WildFive
//
//  Created by naceka on 12.02.12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//
typedef enum{
    XSettingsViewGame,
    XSettingsViewMusic
}XSettingsView;

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"

@class XSettingsViewSizeBackBoard;
@class XSettingsViewSizeAboveBoard;

@interface XSettingsViewController : XAbstractViewController {
    IBOutlet UIImageView *mBackgroundImageView;
    UIScrollView    *mScrollView;
    UILabel         *mLabelTitleFieldSize;
    UILabel         *mLabelTitlePlayerName;
    UILabel         *mLabelTitleBackgroundMusic;
    UILabel         *mLabelTitleSoundEffect;
    UILabel         *mLabelTitleVibratingTone;
    UILabel         *mLabelTitleEnableSound;
    
    UISlider        *mSliderBackgroundMusic;
    UISlider        *mSliderSoundEffect;
    
    UISwitch        *mSwitchEnableSound;
    UISwitch        *mSwitchVibration;    
    
    //new settings
    UIButton        *mButtonTitleGameSettings;
    UIButton        *mButtonTitleMusicSettings;
    
    UILabel         *mLabelTitleGameSettings;
    UILabel         *mLabelTitleMusicSettings;
    
    XSettingsViewSizeBackBoard    *mViewBackBoard; 
    
    UIView          *mViewGameSettings;
    UIView          *mViewMusicSettings;
    
    
}
- (void) saveSettings;

@end
