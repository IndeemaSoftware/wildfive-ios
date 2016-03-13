//
//  EEGameController_hidden.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameController.h"
#import "EEBoard.h"
#import "EEBoardItem.h"
#import "EEMove.h"

#import "EEPlayer_hidden.h"

@interface EEGameController ()  {
    @public
    EEBoard *_board;
    
    EEBoardSize _boardSize;
    EEGameStatus _gameStatus;

    
    EEPlayer *_player;
    EEPlayer *_opponentPlayer;
    EEPlayer *_activePlayer;
    
    @private
}

- (instancetype)initGameController;

- (void)changeActivePlayer;
- (void)changeActivePlayerAndNotifiDelegate;

// Delegate methods
- (void)sendToDelegateActivePlayer;
- (void)sendToDelegateUpdatePoint:(EEBoardPoint)point;
- (void)sendToDelegateFinishResults:(EEFinishResult)finishResults;
- (void)sendToDelegateGameInterrupted:(EEInterruptionReason)reason;

- (void)delegateRequiresSelector:(SEL)selector;

// Utils

@end
