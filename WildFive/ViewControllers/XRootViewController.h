//
//  XRootViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/2/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"
#import "XAnimationDoc.h"
#import "XPurchasing.h"

@class XGameCenterManager;

@interface XRootViewController : XAbstractViewController  <UIAlertViewDelegate, XPurchasingDelegate, UIActionSheetDelegate>  {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UIImageView *mSplashScreenImageView;
    
    IBOutlet UIView *mMenuView;
     IBOutlet UIButton *mButtonNewGame;
     IBOutlet UIButton *mButtonFaceBook;
     IBOutlet UIButton *mButtonTwitter;
     IBOutlet UIButton *mButtonInvite;
     IBOutlet UIButton *mButtonBuyHints;
     IBOutlet UIButton *mButtonSettings;
     IBOutlet UIButton *mButtonAbout;
    // MPAdView *mAdView;
    
@private
    XGameCenterManager * mGameCenterManager;
    XAnimationDoc *mAnimDocView;
    //twitter
	NSMutableArray *mTweets;
    
    BOOL mIsSplashHiden;
}

- (IBAction)newGame:(id)pSender;
- (IBAction)facebookPressed:(id)pSender;
- (IBAction)twitter:(id)pSender;
- (IBAction)about:(id)pSender;
- (IBAction)settings:(id)pSender;
- (IBAction)buyHints:(id)pSender;
- (IBAction)inviteFriendsPressed:(id)pSender;
@end
