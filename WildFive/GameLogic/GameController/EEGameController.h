//
//  EEGameController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EEGameCommon.h"

@class EEPlayer;
@class EEMove;
@protocol EEGameControllerDelegate;

@interface EEGameController : NSObject

@property (nonatomic, readonly) EEPlayer *player;
@property (nonatomic, readonly) EEPlayer *opponentPlayer;
@property (nonatomic, readonly) EEPlayer *activePlayer;

@property (nonatomic, readonly) EEMove *lastPlayerMove;
@property (nonatomic, readonly) EEMove *lastOpponentPlayerMove;

@property (nonatomic, readonly) EEBoardSize boardSize;

@property (nonatomic, weak) id <EEGameControllerDelegate> delegate;

- (EEBoardSign)signAtPoint:(EEBoardPoint)point;
- (EEPlayerType)playerTypeAtPoint:(EEBoardPoint)point;
- (BOOL)isPointInsideGameBoardSize:(EEBoardPoint)point;
- (BOOL)isBoardFreeAtPoint:(EEBoardPoint)point;
- (BOOL)isActionAllowedForPlayer;
- (BOOL)isPlayerActive;
- (BOOL)isOpponentPlayerActive;
- (BOOL)isGameFinished;
- (BOOL)isGameActive;
- (BOOL)isGameInterrupted;

- (void)resetGame;
- (void)stopGame;

- (EEMoveStatus)makeMove:(EEMove*)move;

@end

@protocol EEGameControllerDelegate <NSObject>
@optional
- (void)EEGameController:(EEGameController*)gameController updatedItemAtPoint:(EEBoardPoint)point;
- (void)EEGameController:(EEGameController*)gameController activePlayerHasChanged:(EEPlayer*)activePlayer;
- (void)EEGameController:(EEGameController*)gameController gameFinished:(EEFinishResult)winResult;
- (void)EEGameController:(EEGameController*)gameController gameInterrupted:(EEInterruptionReason)reason;
@end
