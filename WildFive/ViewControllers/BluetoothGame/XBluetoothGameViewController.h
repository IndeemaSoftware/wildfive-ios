//
//  XBluetoothGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 20/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XGameViewControler.h"
#import <GameKit/GameKit.h>
#import "XActivityIndicatorDelegate.h"

#define OPTION_TYPE @"type"
#define GAME_NAME @"game_name"
#define OPPONENT_PEER_ID @"opponent_peer_id"
#define CREATE_GAME @"create_game"
#define CONNECT @"connect"

@class XActivityIndicatorView;
@interface XBluetoothGameViewController : XGameViewControler <GKSessionDelegate, XActivityIndicatorDelegate> {
    IBOutlet UIImageView *mBackgroundImageView;
    
    XActivityIndicatorView *mWaitOnOpponentView;
    
    GKSession *mGameSession;
    
    NSDictionary *mOptions;
    
    NSString *mOpponentPeer;
    
    NSTimer *mBotTimer;
    NSTimer *mWatingTimer;
    
    BOOL mContinueWithBot;
    BOOL mIsAllreadyConnected;
}
- (id)initWithNibName:(NSString *)pNibNameOrNil bundle:(NSBundle *)pNibBundleOrNil options:(NSDictionary*)pOptions;
@end
