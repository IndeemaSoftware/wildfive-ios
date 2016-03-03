//
//  XBluetoothGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 20/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XBluetoothGameViewController.h"
#import "XBot.h"
#import "XAppDelegate.h"
#import "XActivityIndicatorView.h"

@interface XBluetoothGameViewController()
- (void) waitOnDataFromOpponent;
- (void) opponentsTimeout;
- (void) hideWaitingView;
- (void) continueWithBot;
- (void) goBot;
- (void) opponentPushAt:(XBoardPoint)pPoint;
- (void) sendPointToOpponent:(XBoardPoint)pPoint;
- (void) sendSettingsToOpponent;
- (void) sendDisconnectToOpponent;
- (void) mySendDataToPeers: (NSData *) data;
- (void) parseData:(NSData*)pDataFromOpponent;
- (void) connectToPeer:(NSString*)pOpponentPeer;
- (void) goBotWithProperty;
- (void) createGameWithName:(NSString*)pGameName;
- (void) connectToGameWithPeer:(NSString*)pGamePeer;
- (void) releaseSession;
- (void) showMessageOpponentExit;
- (void) showMessageNetworkOff;
@end
@implementation XBluetoothGameViewController

#pragma mark - Initialization -
- (id)initWithNibName:(NSString *)pNibNameOrNil bundle:(NSBundle *)pNibBundleOrNil options:(NSDictionary*)pOptions {
    self = [super initWithNibName:pNibNameOrNil bundle:pNibBundleOrNil level:XGameLevelHard];
    if (self) {
        mContinueWithBot = NO;
        mIsAllreadyConnected = NO;
        mOptions = [pOptions retain];
        
    }
    return self;
}

#pragma mark - Private methods -
- (void) waitOnDataFromOpponent {
    if (mWaitOnOpponentView == nil) {
        mWaitOnOpponentView = [[XActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [mWaitOnOpponentView setMessage:NSLocalizedString(@"Waiting for opponent...", @"selectBluetoothVC") ];
        [mWaitOnOpponentView setHasCancelButton:YES];
        [mWaitOnOpponentView setDelegate:self];
        [self.view addSubview:mWaitOnOpponentView];
    }
}

- (void) opponentsTimeout {
    if (mIsAllreadyConnected) {
        [self showMessageOpponentExit];
    }
    mWatingTimer = nil;
}

- (void) hideWaitingView {
    if (mWaitOnOpponentView != nil) {
        [mWaitOnOpponentView removeFromSuperview];
        [mWaitOnOpponentView release];
        mWaitOnOpponentView = nil;
    }
}

- (void) continueWithBot {
    if (!mContinueWithBot) {
        if (mOpponentPeer) {
            [mOpponentPeer release];
            mOpponentPeer = nil;
        }
        [self releaseSession];
        mContinueWithBot = YES;
        [self initBotPlayer];
        if (mBotPlayer.botType == mCurrentPlayer) {
            [self goBot];
        }
        
        [self showRightButton];
    }
}

- (void) goBot {
    if (mContinueWithBot && mBotPlayer) {
        VKSafeTimerRelease(mBotTimer);
        XBoardPoint lBotPoint = [mBotPlayer findBestPosition];
        NSUInteger lBotValue = ABS([self valueAtPoint:lBotPoint player:mBotPlayer.botType]);
        NSUInteger lOpponentValue = ABS([self valueAtPoint:lBotPoint player:[self currentOpponent]]);
        NSInteger lValue = (lOpponentValue + lBotValue - 16) / 10;
        if (lValue <= 0) {
            lValue = 70;
        }
        if (lValue < 3) {
            lValue = 3;
        }
        CGFloat lTime = 7.0 / lValue;
        NSDictionary *lProperty = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:lBotPoint.x],
                                   @"bot_point_x",
                                   [NSNumber numberWithInteger:lBotPoint.y],
                                   @"bot_point_y", nil];
        mBotTimer = [NSTimer scheduledTimerWithTimeInterval:lTime
                                                     target:self 
                                                   selector:@selector(goBotWithProperty) 
                                                   userInfo:lProperty
                                                    repeats:NO];
        [lProperty release];
    }
}

- (void) opponentPushAt:(XBoardPoint)pPoint {
    [self fillCellAtPoint:pPoint forPlayer:mCurrentPlayer];
}

- (void) sendPointToOpponent:(XBoardPoint)pPoint {
    NSDictionary *lProperty = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"push_point",
                               @"message_type",
                               [NSNumber numberWithInteger:pPoint.x],
                               @"bot_point_x",
                               [NSNumber numberWithInteger:pPoint.y],
                               @"bot_point_y", nil];
    
    NSData *lData  = [NSKeyedArchiver archivedDataWithRootObject:lProperty];
    [self mySendDataToPeers:lData];
    [lProperty release];
    
    VKSafeTimerRelease(mWatingTimer);
    mWatingTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_OUT target:self selector:@selector(opponentsTimeout) userInfo:nil repeats:NO];
    
}

- (void) sendSettingsToOpponent {
    NSDictionary *lSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"game_settings",
                               @"message_type",
                               [NSNumber numberWithUnsignedInteger:mBoardSize.width],
                               @"board_width",
                               [NSNumber numberWithUnsignedInteger:mBoardSize.height],
                               @"board_height",
                               [NSNumber numberWithUnsignedInteger:[self opponentForPlayer:mOwnPlayerType]],
                               @"player_type",
                               nil];
    NSData *lData  = [NSKeyedArchiver archivedDataWithRootObject:lSettings];
    [self mySendDataToPeers:lData];
    [lSettings release];
}

- (void) sendDisconnectToOpponent {
    NSDictionary *lSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"disconnect",
                               @"message_type",
                               nil];
    NSData *lData  = [NSKeyedArchiver archivedDataWithRootObject:lSettings];
    [self mySendDataToPeers:lData];
    [lSettings release];
}

- (void) mySendDataToPeers:(NSData *)data {
    if (data != nil) {
        if (mGameSession) {
            if (mOpponentPeer) {
                NSError *lError = nil;
                [mGameSession sendData:data toPeers:[NSArray arrayWithObject:mOpponentPeer] withDataMode:GKSendDataReliable error:&lError];
                DLog(@"error when send %@", lError);
            }
        }
    }
}

- (void) parseData:(NSData*)pDataFromOpponent {
    NSDictionary *lDictionary =  (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:pDataFromOpponent];
    NSString *lMessageValue = [lDictionary valueForKey:@"message_type"];
    if (lMessageValue != nil) {
        if ([lMessageValue isEqualToString:@"game_settings"]) {
            NSUInteger lBoardWidth = [[lDictionary valueForKey:@"board_width"] integerValue];
            NSUInteger lBoardHeight = [[lDictionary valueForKey:@"board_height"] integerValue];
            mOwnPlayerType = [[lDictionary valueForKey:@"player_type"] integerValue];
            mBoardSize = XBoardSizeMake(lBoardWidth, lBoardHeight);
            [self initBoardWithSize:mBoardSize];
            [self restartGame];
        } else if ([lMessageValue isEqualToString:@"push_point"]) {
            NSInteger lBotX = [[lDictionary valueForKey:@"bot_point_x"] integerValue];
            NSInteger lBotY = [[lDictionary valueForKey:@"bot_point_y"] integerValue];
            XBoardPoint lBotPoint = XBoardPointMake(lBotX, lBotY);
            [self opponentPushAt:lBotPoint];
        } else if ([lMessageValue isEqualToString:@"disconnect"]) {
            if (mIsAllreadyConnected) {
                [self showMessageOpponentExit];
            }
        }
    }
}

- (void) connectToPeer:(NSString*)pOpponentPeer {
    mIsAllreadyConnected = YES;
    [mGameSession connectToPeer:mOpponentPeer withTimeout:20];
}


- (void) goBotWithProperty {
    NSDictionary *pProperty = [mBotTimer userInfo];
    NSInteger lBotX = [[pProperty valueForKey:@"bot_point_x"] integerValue];
    NSInteger lBotY = [[pProperty valueForKey:@"bot_point_y"] integerValue];
    XBoardPoint lBotPoint = XBoardPointMake(lBotX, lBotY);
    [self fillCellAtPoint:lBotPoint forPlayer:mBotPlayer.botType];
    mBotTimer = nil;
}

- (void) createGameWithName:(NSString*)pGameName {
    mContinueWithBot = NO;
    [self restartGame];

    [self waitOnDataFromOpponent];
    
    [self releaseSession];
    
    //init session as server
    mGameSession = [[GKSession alloc] initWithSessionID:@"WildFiveBluetoothGame" displayName:pGameName sessionMode:GKSessionModeServer];
    mGameSession.available = YES;
    [mGameSession setDelegate:self];
    [mGameSession setDataReceiveHandler:self withContext:nil];
}

- (void) connectToGameWithPeer:(NSString*)pGamePeer {
    [self releaseSession];
    if (mOpponentPeer) {
        [mOpponentPeer release];
        mOpponentPeer = nil;
    }
    mOpponentPeer = [[NSString alloc] initWithString:pGamePeer];
    //init session as client
    mGameSession = [[GKSession alloc] initWithSessionID:@"WildFiveBluetoothGame" displayName:@"wildfiveclient" sessionMode:GKSessionModeClient];
    mGameSession.available = YES;
    [mGameSession setDelegate:self];
    [mGameSession setDataReceiveHandler:self withContext:nil];
}

- (void) releaseSession {
    if (mGameSession != nil) {
        mGameSession.available = NO;
        [mGameSession disconnectFromAllPeers];
        [mGameSession setDataReceiveHandler: nil withContext: nil];
        mGameSession.delegate = nil;
        [mGameSession release];
        mGameSession = nil;
    }
}

- (void) showMessageOpponentExit {
    if (mIsAllreadyConnected) {
        mIsAllreadyConnected = NO;
        XMessageView *lCreateNewGameMeesage = [[XMessageView alloc] initWithTitle:NSLocalizedString(@"Your opponent has left game!", @"selectBluetoothVC")  message:NSLocalizedString(@"Do you want to continue with bot?", @"selectBluetoothVC")  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"selectBluetoothVC") ];
        [lCreateNewGameMeesage addButtonWithTitle:NSLocalizedString(@"YES", @"selectBluetoothVC") ];
        [lCreateNewGameMeesage setPosition:XMessageViewPositionCenter];
        [lCreateNewGameMeesage setTag:1];
        [lCreateNewGameMeesage show];
        [lCreateNewGameMeesage release];
    }
}

- (void) showMessageNetworkOff {
    XMessageView *lCreateNewGameMeesage = [[XMessageView alloc] initWithTitle:NSLocalizedString(@"Network problems", @"selectBluetoothVC") message:NSLocalizedString(@"Please turn on wi-fi.", @"selectBluetoothVC") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"selectBluetoothVC")];
    [lCreateNewGameMeesage setPosition:XMessageViewPositionCenter];
    [lCreateNewGameMeesage setTag:2];
    [lCreateNewGameMeesage show];
    [lCreateNewGameMeesage release];
}

- (void)hintNavigationButtonPressed:(id)pSender {
    if (mIsAllreadyConnected) {
        [super hintNavigationButtonPressed:pSender];
    }
}

#pragma mark - XActivityIndicatorDelegate - 
- (void) cancelButtonPressedInActivityIndicator {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Session delegate -
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state) {
        case GKPeerStateAvailable:{
            if (([mGameSession sessionMode] == GKSessionModeClient) && ([mOpponentPeer isEqualToString:peerID])) {
                [self connectToPeer:mOpponentPeer];
            }
            break;
        }
        case GKPeerStateConnected: {
            mIsAllreadyConnected = YES;
            if ([mGameSession sessionMode] == GKSessionModeServer) {
                [self sendSettingsToOpponent];
                mGameSession.available = NO;
            } else {
                [self hideWaitingView];
            }
            break;
        }
        case GKPeerStateDisconnected:{
            [self showMessageOpponentExit];
            break;
        }
        default:
            break;
    }
} 

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    VKSafeTimerRelease(mWatingTimer);
    [self parseData:data];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    if (!mIsAllreadyConnected) {
        NSError *lError = nil;
        [self unBlockBoard];
        if (mOpponentPeer != nil) {
            [mOpponentPeer release];
            mOpponentPeer = nil;
        }
        
        mOpponentPeer = [[NSString alloc] initWithString:peerID];
        [mGameSession acceptConnectionFromPeer:peerID error:&lError];
        [self connectToPeer:peerID];
        [self hideWaitingView];
        DLog(@"error = %@", lError);
    }
}

- (BOOL)acceptConnectionFromPeer:(NSString *)peerID error:(NSError **)error {
    DLog(@"acceptConnectionFromPeer");
    return !mIsAllreadyConnected;
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    DLog(@"didFailWithError :%@", error);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    DLog(@"connectionWithPeerFailed :%@", error);
}

#pragma mark - Reloaded methods
- (void) gameFinishedWinner:(XPlayerType)pWinner {
    [super gameFinishedWinner:pWinner];
    VKSafeTimerRelease(mBotTimer);
}

- (void) restartGame {
    [super restartGame];
    if (mContinueWithBot) {
        VKSafeTimerRelease(mBotTimer);
        [self initBotPlayer];
        if (mBotPlayer.botType == mCurrentPlayer) {
            [self goBot];
        }
    }
}

- (void) boardViewPushAt:(XBoardPoint)pPosition {
    if ([self hasBoardPoint:pPosition]) {
        if ([self isEmptyCell:pPosition]) {
            BOOL lIsFinished = NO;
            lIsFinished = [self fillCellAtPoint:pPosition forPlayer:mCurrentPlayer];
            [self sendPointToOpponent:pPosition];
            
            if (!lIsFinished) {
                if (mContinueWithBot) {
                    [self goBot];
                } else {
//                    [self ddd];
                }
            }
        }
    }
}

- (void)rightNavigationButtonPressed:(id)pSender {
    [self restartGame];
}

#pragma mark - message View delegate's methods
- (void) messageView:(XMessageView *)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex {
    [super messageView:pMessageView clickedButtonAtIndex:pButtonIndex];
    if (1 == [pMessageView tag]) {
        if (mIsGameFinished) {
            [self restartGame];
        }
        [self continueWithBot];
    }
}

- (void) messageViewCancelButtonPressed:(XMessageView *)pMessageView {
    if (0 == [pMessageView tag]) {
        
    } else if (1 == [pMessageView tag]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (2 == [pMessageView tag]) {
        [super messageViewCancelButtonPressed:pMessageView];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self blockBoard];
    self.navigationItem.rightBarButtonItem = nil;

    XReachabilityNet *lNet = [(XAppDelegate*)[[UIApplication sharedApplication] delegate] currentReachabilityNet];
    if ([lNet currentReachabilityStatus] == 0) {
        [self showMessageNetworkOff];
    } else {
        if (mOptions != nil) {
            NSString *lType = [mOptions objectForKey:OPTION_TYPE];
            if (lType != nil) {
                if ([lType isEqualToString:CREATE_GAME]) {
                    NSString *lNewGameName = [mOptions objectForKey:GAME_NAME];
                    [self createGameWithName:lNewGameName];
                } else if ([lType isEqualToString:CONNECT]) {
                    NSString *lOpponentPeer = [mOptions objectForKey:OPPONENT_PEER_ID];
                    [self waitOnDataFromOpponent];
                    [self connectToGameWithPeer:lOpponentPeer];
                }
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - InterfaceIneraction -
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (void) viewWillDisappear:(BOOL)animated {
    VKSafeTimerRelease(mBotTimer);
    VKSafeTimerRelease(mWatingTimer);
    mIsAllreadyConnected = NO;
    if (mGameSession != nil) {
        if (mIsAllreadyConnected) {
            [self sendDisconnectToOpponent];
        }
        mGameSession.available = NO;
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [super viewWillDisappear:animated];
}


#pragma mark - Dealloc -
- (void) dealloc {
    [self releaseSession];
    
    XSafeRelease(mOptions);
    XSafeRelease(mWaitOnOpponentView);

    if (mOpponentPeer) {
        [mOpponentPeer release];
        mOpponentPeer = nil;
    }
    [mBackgroundImageView release];
    [super dealloc];
}
@end
