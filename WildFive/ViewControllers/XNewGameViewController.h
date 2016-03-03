//
//  XNewGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XAppDelegate.h"

@interface XNewGameViewController : XAbstractViewController  {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UIButton *mOnlineGameButton;
    IBOutlet UIButton *mCreateGameButton;    
    IBOutlet UIButton *mFindGameButton;
    IBOutlet UIButton *mOfflineGameButton;
    IBOutlet UIButton *mBluetoothGameButton;
}

- (IBAction)onlineGame:(id)pSender;
- (IBAction)createGameButtonPressed:(id)pSender;
- (IBAction)findGameButtonPressed:(id)pSender;
- (IBAction)offlineGame:(id)pSender;
- (IBAction)bluetoothGame:(id)pSender;

@end
