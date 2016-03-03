//
//  XOnlineGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/18/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XGameViewControler.h"
#import <GameKit/GameKit.h>
#import "XActivityIndicatorDelegate.h"
#import "XMessageViewDelegate.h"

typedef enum {
    XOnlineGameTypeCreate,
    XOnlineGameTypeConnect,
    XOnlineGameTypeFriend
} XOnlineGameType;

@class XActivityIndicatorView;
@interface XOnlineGameViewController : XGameViewControler <GKMatchDelegate, XActivityIndicatorDelegate, XMessageViewDelegate> {
    IBOutlet UIImageView *mBackgroundImageView;
    
    XActivityIndicatorView *mWaitingView;
    
    GKMatch *mMatch;
    
    NSTimer *mBotTimer;
    NSTimer *mWaiteTimer;
    
    XOnlineGameType mGameType;
    
    BOOL mContinueWithBot;
    BOOL mIsAlreadyConnected;
    BOOL mRestartedOpponent;
    BOOL mSelfRestart;
    BOOL mNeedRestart;
}

- (id)initWithNibName:(NSString *)pNibNameOrNil bundle:(NSBundle *)pNibBundleOrNil withType:(XOnlineGameType)pGameType;

@end
