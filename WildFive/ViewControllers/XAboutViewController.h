//
//  XAboutViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"
#import "XAnimationDoc.h"

@interface XAboutViewController : XAbstractViewController<XAnimationDocDelegate> {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UIImageView *mBoardImageView;
    IBOutlet UILabel *mTitleLabel;
    IBOutlet UIButton *mCreditsButton;
    IBOutlet UITextView *mAboutText;
    IBOutlet UIButton *mHowToPlayButton;
    XAnimationDoc *mAnimDoc;
}

- (IBAction) creditsButtonPressed:(id)pSender;
- (IBAction)howToPlayButtonPressed:(id)sender;

@end
