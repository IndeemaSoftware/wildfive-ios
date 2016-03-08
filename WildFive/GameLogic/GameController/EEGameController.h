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
@protocol EEGameControllerDelegate;

@interface EEGameController : NSObject

@property (nonatomic, readonly) EEPlayer *player;
@property (nonatomic, readonly) EEPlayer *opponentPlayer;
@property (nonatomic, readonly) EEPlayer *activePlayer;

@property (nonatomic, readonly) EEBoardSize boardSize;

@property (nonatomic, weak) id <EEGameControllerDelegate> delegate;

- (EEBoardSign)signAtPoint:(EEBoardPoint)point;
- (EEPlayerType)playerTypeAtPoint:(EEBoardPoint)point;
- (BOOL)isPointInsideGameBoardSize:(EEBoardPoint)point;
- (BOOL)isBoardFreeAtPoint:(EEBoardPoint)point;
- (BOOL)isActionAllowedForPlayer;

- (void)resetGame;
- (EEPutStatus)putValuesForPlayerAtPoint:(EEBoardPoint)point;
- (EEPutStatus)putValuesForActivePlayerAtPoint:(EEBoardPoint)point;

@end

@protocol EEGameControllerDelegate <NSObject>
- (void)EEGameController:(EEGameController*)gameController updateCellAtPoint:(EEBoardPoint)point;
- (void)EEGameController:(EEGameController*)gameController activePlayerHasChanged:(EEPlayer*)activePlayer;
@end
