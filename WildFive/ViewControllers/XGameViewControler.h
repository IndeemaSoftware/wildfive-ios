//
//  XGameViewControler.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/10/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XGameEnums.h"
#import "XGameBoardDelegate.h"
#import "XMessageViewDelegate.h"
#import "XAppDelegate.h"
#import "XAnimationDoc.h"

#define LEADER_BOARD_CATEGORY @"1"
@class XBot;
@class XGameBoard;

@interface XGameViewControler : XAbstractViewController <XGameBoardDelegate, XMessageViewDelegate,XAnimationDocDelegate>{
    NSMutableArray *mBoardArray;
    NSMutableArray *mValueArray;
    NSMutableArray *mLineArray;
    NSArray *mWeightArray;
    
    UIImageView *mCurrentPlayerImageView;
    
    XBot *mBotPlayer;
    
    XGameBoard *mGameBoard;
    
    XGameLevel mLevel;
    
    XBoardSize mBoardSize;
    XAnimationDoc *mAnimationDocView ;
    XPlayerType mOwnPlayerType;
    XPlayerType mCurrentPlayer;
    XPlayerType mWinner;
    
    NSUInteger mTotalLines;
    
    BOOL mIsGameFinished;
    BOOL isBoardAvailable;
    BOOL mIsPlayerGame;    
}
@property (nonatomic, readonly) XPlayerType winner;

//init methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil level:(XGameLevel)pLevel;
- (void) initBotPlayer;
- (void) initWeightArrayForLevel:(XGameLevel)pLevel;
- (void) initArraysForBoardSize:(XBoardSize)pBoardSize;
- (void) initBoardWithSize:(XBoardSize)pSize;

//this method restarts game
- (void) makeHint;
- (void) restartGame;
- (void) gameFinishedWinner:(XPlayerType)pWinner;
- (BOOL) fillCellAtPoint:(XBoardPoint)pFillPoint forPlayer:(XPlayerType)pPlayer; 
- (void) boardViewPushAt:(XBoardPoint) pPosition;
- (BOOL) isEmptyCell:(XBoardPoint)pPoint;
- (BOOL) hasBoardPoint:(XBoardPoint)pPoint;
- (void) blockBoard;
- (void) unBlockBoard;

- (XPlayerType) currentOpponent;
- (XPlayerType) currentPlayer;
- (XPlayerType) opponentForPlayer:(XPlayerType)pPlayer;
- (void) changeCurrentPlayer;


//work with arrays
- (XPlayerType) boardAtPoint:(XBoardPoint)pPoint;
- (NSInteger) valueAtPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer;
- (NSInteger) lineAtPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer direction:(XLineDirection)pLineDirection;
- (NSInteger) weightAt:(NSUInteger)pIndex;
@end
