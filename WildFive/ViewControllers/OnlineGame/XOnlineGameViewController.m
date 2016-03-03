//
//  XOnlineGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/18/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XOnlineGameViewController.h"
#import "XActivityIndicatorView.h"
#import "XBot.h"


#define PLAYER_CREATOR   0xFFFF0000
#define PLAYER_CONNECTOR 0x0000FFFF

@interface XOnlineGameViewController()
- (void) waitOnDataFromOpponent;
- (void) timeout;
- (void) continueWithBot;
- (void) continueGame;
- (void) goBot;
- (void) opponentPushAt:(XBoardPoint)pPoint;
- (void) sendPointToOpponent:(XBoardPoint)pPoint;
- (void) sendSettingsToOpponent;
- (void) sendRestartToOpponent;
- (void) mySendDataToOpponent: (NSData *) data;
- (void) parseData:(NSData*)pDataFromOpponent;
//connecting
- (void) showWaitingViewWithMessage:(NSString*)pMessage;
- (void) hideWaitingView;
- (void) startCreateGame;
- (void) startFindGames;
- (void) stopFindGames;
- (void) showMessageOpponentExit;
@end

@implementation XOnlineGameViewController

#pragma mark - Initialization -

- (id)initWithNibName:(NSString *)pNibNameOrNil bundle:(NSBundle *)pNibBundleOrNil withType:(XOnlineGameType)pGameType {
    self = [super initWithNibName:pNibNameOrNil bundle:pNibBundleOrNil level:XGameLevelHard];
    if (self) {
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        mGameType = pGameType;
        
        mContinueWithBot = NO;
        mIsAlreadyConnected = NO;
        mRestartedOpponent = NO;
        mSelfRestart = NO;
        mNeedRestart = NO;
        
        if (mGameType == XOnlineGameTypeCreate) {
            [self showWaitingViewWithMessage:NSLocalizedString(@"Waiting for opponent...", @"OnlineGameV") ];
            [self startCreateGame];
        } else if (mGameType == XOnlineGameTypeConnect) {
            [self showWaitingViewWithMessage:NSLocalizedString(@"Searching for game...",@"OnlineGameV")];
            [self startFindGames];
        }
        
        
    }
    return self;
}

#pragma mark - Private methods -
- (void) waitOnDataFromOpponent {
    VKSafeTimerRelease(mWaiteTimer);
    mWaiteTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_OUT
                                                 target:self 
                                               selector:@selector(timeout) 
                                               userInfo:NULL
                                                repeats:NO];
}

- (void) timeout {
    [mMatch disconnect];
    [self showMessageOpponentExit];
    mWaiteTimer = nil;
}

- (void) continueWithBot {
    if (!mContinueWithBot) {
        [self hideWaitingView];
        mContinueWithBot = YES;
        [self initBotPlayer];
        if (mBotPlayer.botType == mCurrentPlayer) {
            [self goBot];
        }
        [self showRightButton];
    }
}

- (void) continueGame {
    if (mSelfRestart && mRestartedOpponent) {
        [self restartGame];
        mSelfRestart = NO;
        mRestartedOpponent = NO;
        [self hideWaitingView];
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
    [self mySendDataToOpponent:lData];
    [lProperty release];
}

- (void) goBotWithProperty {
    NSDictionary *pProperty = [mBotTimer userInfo];
    NSInteger lBotX = [[pProperty valueForKey:@"bot_point_x"] integerValue];
    NSInteger lBotY = [[pProperty valueForKey:@"bot_point_y"] integerValue];
    XBoardPoint lBotPoint = XBoardPointMake(lBotX, lBotY);
    [self fillCellAtPoint:lBotPoint forPlayer:mBotPlayer.botType];
    mBotTimer = nil;
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
    [self mySendDataToOpponent:lData];
    [lSettings release];
}

- (void) sendRestartToOpponent {
    NSDictionary *lSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"restart_game",
                               @"message_type",
                               nil];
    NSData *lData  = [NSKeyedArchiver archivedDataWithRootObject:lSettings];
    [self mySendDataToOpponent:lData];
    [lSettings release];
}

- (void) mySendDataToOpponent:(NSData*)data
{
    if ((data != nil) && (mIsAlreadyConnected)) {
        NSError *lError = nil;
        BOOL lSuccess = [mMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:NULL];
        DLog(@"send lSuccess %i", (int)lSuccess);
        DLog(@"error when send %@", lError);
    }
}

- (void) parseData:(NSData*)pDataFromOpponent {
    NSDictionary *lDictionary =  (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:pDataFromOpponent];
    NSString *lMessageValue = [lDictionary valueForKey:@"message_type"];
    DLog(@"lDictionary = %@", lDictionary);
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
        } else if ([lMessageValue isEqualToString:@"restart_game"]) {
            if (mIsAlreadyConnected) {
                mRestartedOpponent = YES;
                [self continueGame];
            }
        } else if ([lMessageValue isEqualToString:@"disconnect"]) {
            if (mIsAlreadyConnected) {
                [self showMessageOpponentExit];
            }
        }
    }
}

- (void) showWaitingViewWithMessage:(NSString*)pMessage {
    if (mWaitingView == nil) {
        mWaitingView = [[XActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        
        [mWaitingView setMessage:pMessage];
        [mWaitingView setHasCancelButton:YES];
        [mWaitingView setDelegate:self];
    
//        [mWaitingView setFrame:CGRectMake(0, 0, 320, 568)];
//        [mWaitingView setBackgroundColor:[UIColor redColor]];
        
        [self.view addSubview:mWaitingView];
 
        
    }
}

- (void) hideWaitingView {
    if (mWaitingView != nil) {
        [mWaitingView removeFromSuperview];
        [mWaitingView release];
        mWaitingView = nil;
    }
}

- (void) startCreateGame {
    GKMatchRequest *lMatchRequest = [[GKMatchRequest alloc] init];
    [lMatchRequest setMinPlayers:2];
    [lMatchRequest setMaxPlayers:2];
    [lMatchRequest setPlayerAttributes:PLAYER_CREATOR];
    //    [lMatchRequest setPlayerGroup:1];
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:lMatchRequest withCompletionHandler:^(GKMatch *match, NSError *error) {
        if (error) {
            DLog(@"find error %@", [error localizedDescription]);
            UIAlertView *lAlert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [lAlert show];
            [lAlert release];
        } else if (match != nil) {
            DLog(@"a match has been found %@", match);
            DLog(@"a match expectedPlayerCount %i", match.expectedPlayerCount);
            mMatch = [match retain];
            [mMatch setDelegate:self];
        }
    }];
    
    [lMatchRequest release];
    DLog(@"end startCreateGame");
}

- (void) startFindGames {
    GKMatchRequest *lMatchRequest = [[GKMatchRequest alloc] init];
    [lMatchRequest setMinPlayers:2];
    [lMatchRequest setMaxPlayers:2];
    [lMatchRequest setPlayerAttributes:PLAYER_CONNECTOR];
    //    [lMatchRequest setPlayerGroup:2];
//    [lMatchRequest setPlayersToInvite:[NSArray arrayWithObject:[[GKLocalPlayer localPlayer].friends objectAtIndex:0]]];
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:lMatchRequest withCompletionHandler:^(GKMatch *match, NSError *error) {
        if (error) {
            DLog(@"find error %@", [error localizedDescription]);
        } else if (match != nil) {
            DLog(@"a match has been found %@", match);
            DLog(@"a match expectedPlayerCount %i", match.expectedPlayerCount);
            if (!mIsAlreadyConnected) {
                if (mMatch != nil) {
                    [mMatch disconnect];
                    [mMatch release];
                }
                mMatch = [match retain];
                [mMatch setDelegate:self];
            }
        }
    }];
    
    [lMatchRequest release];
    DLog(@"end startFindGames");
}

- (void) stopFindGames {
    [[GKMatchmaker sharedMatchmaker] cancel];
    [self hideWaitingView];
}

- (void) showMessageOpponentExit {
    mIsAlreadyConnected = NO;
    VKSafeTimerRelease(mWaiteTimer);
    XMessageView *lCreateNewGameMeesage = [[XMessageView alloc] initWithTitle:NSLocalizedString(@"Your opponent has left game!",@"XOnlineVC") message:NSLocalizedString(@"Continue with bot?",@"XOnlineVC") delegate:self cancelButtonTitle:NSLocalizedString(@"NO",@"XOnlineVC")];
    [lCreateNewGameMeesage addButtonWithTitle:NSLocalizedString(@"YES",@"XOnlineVC")];
    [lCreateNewGameMeesage setPosition:XMessageViewPositionCenter];
    [lCreateNewGameMeesage setTag:1];
    [lCreateNewGameMeesage show];
    [lCreateNewGameMeesage release];
}

- (void)hintNavigationButtonPressed:(id)pSender {
    if (mIsAlreadyConnected) {
        [super hintNavigationButtonPressed:pSender];
    }
}

#pragma mark - Reloaded methods
- (void) gameFinishedWinner:(XPlayerType)pWinner {
    [super gameFinishedWinner:pWinner];
    VKSafeTimerRelease(mBotTimer);
    VKSafeTimerRelease(mWaiteTimer);
}

- (void) restartGame {
    [super restartGame];
    if (mContinueWithBot) {
        VKSafeTimerRelease(mBotTimer);
        [self initBotPlayer];
        if (mBotPlayer.botType == mCurrentPlayer) {
            [self goBot];
        }
    } else {
        if (mOwnPlayerType != mCurrentPlayer) {
           [self waitOnDataFromOpponent]; 
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
                    [self waitOnDataFromOpponent];
                }
            }
        }
    }
}

- (void)rightNavigationButtonPressed:(id)pSender {
    [self restartGame];
}

#pragma mark - XActivityIndicatorDelegate - 
- (void) cancelButtonPressedInActivityIndicator {
    [[GKMatchmaker sharedMatchmaker] cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - message View delegate's methods
- (void) messageView:(XMessageView *)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex {
    if (0 == [pMessageView tag]) {
        if (0 == pButtonIndex) {
            if (mContinueWithBot) {
                [self restartGame];
            } else {
                [self showWaitingViewWithMessage:NSLocalizedString(@"Waiting...", @"OnlineGameV") ];
                mSelfRestart = YES;
                [self continueGame];
                [self sendRestartToOpponent];
            }
        } else {
            mIsAlreadyConnected = NO;
            [mMatch disconnect];
        }
    } else if (1 == [pMessageView tag]) {
        if (mIsGameFinished) {
            [self restartGame];
        }
        [self continueWithBot];
    }
}

- (void) messageViewCancelButtonPressed:(XMessageView *)pMessageView {
    mIsAlreadyConnected = NO;
    if (0 == [pMessageView tag]) {
        
    } else if (1 == [pMessageView tag]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) messageView:(XMessageView*)pMessageView endEditingTextField:(NSString*)pTextValue {
    
}

#pragma mark - CGMatchDelegate -
- (void) match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    
    switch (state) {
        case GKPlayerStateConnected: {
            DLog(@"GKPlayerStateConnected");
            [self stopFindGames];
            mIsAlreadyConnected = YES;
            if (mGameType == XOnlineGameTypeCreate) {
                [self sendSettingsToOpponent];
            }
            break;
        }
        case GKPlayerStateDisconnected: {
            DLog(@"GKPlayerStateDisconnected");
            if (mIsAlreadyConnected) {
                [self showMessageOpponentExit];
            }
            break;
        }
        case GKPlayerStateUnknown: {
            DLog(@"GKPlayerStateUnknown");
            break;
        }
        default:
            break;
    }
    DLog(@"match expectedPlayerCount %@", match.playerIDs);
//    if (!self.matchStarted && match.expectedPlayerCount == 0)
//    {
//        self.matchStarted = YES;
//        // handle initial match negotiation.
//    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    VKSafeTimerRelease(mWaiteTimer);
    [self parseData:data];
    DLog(@"didReceiveData frome player: %@", playerID);
}

- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    DLog(@"connectionWithPlayer: %@ Failed: %@", playerID, error);
}

- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID {
    DLog(@"shouldReinvitePlayer: %@", playerID);
    return YES;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    mIsAlreadyConnected = NO;
    [mMatch disconnect];
    [[GKMatchmaker sharedMatchmaker] cancel];
    VKSafeTimerRelease(mBotTimer);
    VKSafeTimerRelease(mWaiteTimer);
    [super viewWillDisappear:animated];
}

#pragma mark - InterfaceIneraction -
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Dealloc -
- (void) dealloc {
    [mBackgroundImageView release];
    XSafeRelease(mWaitingView);
    [mMatch release];
    [super dealloc];
}

@end
