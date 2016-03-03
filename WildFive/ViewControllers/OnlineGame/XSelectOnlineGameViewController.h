//
//  XSelectOnlineGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"

@interface XSelectOnlineGameViewController : XAbstractViewController {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UIButton *mCreateGameButton;
    IBOutlet UIButton *mFindGameButton;
    IBOutlet UIButton *mPlayWithFriendButton;
}

- (IBAction)createGameButtonPressed:(id)pSender;
- (IBAction)findGameButtonPressed:(id)pSender;
- (IBAction)playWithFriendButtonPressed:(id)pSender;
@end
