//
//  EEGameController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameController.h"
#import "EEGameController_hidden.h"

@implementation EEGameController

#pragma mark - Public methods
- (instancetype)init {
    NSAssert(NO, @"You are not able to create instance of that class dirrectly.");
    return nil;
}

- (EEBoardSign)signAtPoint:(EEBoardPoint)point {
    if (![self isPointInsideGameBoardSize:point]) {
        return EEBoardSignError;
    }
    
    return [_board itemAtPoint:point].boardSign;
}

- (EEPlayerType)playerTypeAtPoint:(EEBoardPoint)point {
    if (![self isPointInsideGameBoardSize:point]) {
        return EEPlayerTypeError;
    }
    
    return [_board itemAtPoint:point].playerType;
}

- (BOOL)isPointInsideGameBoardSize:(EEBoardPoint)point {
    return EEBoardPointIsInsideBoard(point, _boardSize);
}

- (BOOL)isBoardFreeAtPoint:(EEBoardPoint)point {
    if ([self isPointInsideGameBoardSize:point]) {
        return NO;
    } else {
        return [_board itemAtPoint:point].boardSign == EEBoardSignNone;
    }
}

- (BOOL)isActionAllowedForPlayer {
    return [self isPlayerActive] && [self isGameActive];
}

- (BOOL)isPlayerActive {
    return (_player.type == _activePlayer.type);
}

- (BOOL)isOpponentPlayerActive {
    return (_opponentPlayer.type == _activePlayer.type);
}

- (BOOL)isGameFinished {
    return (_gameStatus == EEGameStatusFinish);
}

- (BOOL)isGameActive {
    return (_gameStatus == EEGameStatusActive);
}

- (void)resetGame {
    if (_player.type == EEPlayerTypeX) {
        _activePlayer = _player;
    } else {
        _activePlayer = _opponentPlayer;
    }
    
    _gameStatus = EEGameStatusActive;
}

- (void)stopGame {
    
}

- (EEMoveStatus)makeMove:(EEMove*)move {
    // check for game status and return an error if game is finished
    if (![self isGameActive]) {
        return EEMoveStatusGameFinished;
    }
    
    // update board values with possible returned errors
    EEMoveStatus lMoveStatus = [_board updateBoardValuesWithMove:move];
    if (lMoveStatus != EEMoveStatusSuccess) {
        return lMoveStatus;
    }
    
    //notifi delegate about update in board
    [self sendToDelegateUpdatePoint:move.point];
    
    // check if we have winner
    EEFinishResult lFinishResult = [_board checkForWinnerForMove:move];
    if (lFinishResult.hasWinner) {
        _gameStatus = EEGameStatusFinish;
        [self sendToDelegateFinishResults:lFinishResult];
    } else {
        // check for possible turns and free points/items
        if ((_board.totalLines <= 0) || ![_board hasFreeItems]) {
            _gameStatus = EEGameStatusFinish;
            
            lFinishResult.hasWinner = NO;
            [self sendToDelegateFinishResults:lFinishResult];
        } else {
            [self changeActivePlayerAndNotifiDelegate];
        }
    }
    
    return EEMoveStatusSuccess;
}

#pragma mark - Private methods
- (instancetype)initGameController {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)changeActivePlayer {
    if ([self isPlayerActive]) {
        _activePlayer = _opponentPlayer;
    } else {
        _activePlayer = _player;
    }
}

- (void)changeActivePlayerAndNotifiDelegate {
    [self changeActivePlayer];
    [self sendToDelegateActivePlayer];
}

- (void)sendToDelegateActivePlayer {
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(EEGameController:activePlayerHasChanged:)]) {
            [self.delegate EEGameController:self activePlayerHasChanged:_activePlayer];
        }
    } else {
        DLog(@"EEGameController has no delegate!!!");
    }
}

- (void)sendToDelegateUpdatePoint:(EEBoardPoint)point {
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(EEGameController:updatedItemAtPoint:)]) {
            [self.delegate EEGameController:self updatedItemAtPoint:point];
        }
    } else {
        DLog(@"EEGameController has no delegate!!!");
    }
}

- (void)sendToDelegateFinishResults:(EEFinishResult)finishResults {
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(EEGameController:activePlayerHasChanged:)]) {
            [self.delegate EEGameController:self gameFinished:finishResults];
        }
    } else {
        DLog(@"EEGameController has no delegate!!!");
    }
}

- (void)sendToDelegateGameInterrupted:(EEInterruptionReason)reason {
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(EEGameController:gameInterrupted:)]) {
            [self.delegate EEGameController:self gameInterrupted:reason];
        }
    } else {
        DLog(@"EEGameController has no delegate!!!");
    }
}

- (void)delegateRequiresSelector:(SEL)selector {
    NSAssert2([self.delegate respondsToSelector:selector], @"EEGameController required delegate's methods %@ not found in Delegate %@", NSStringFromSelector(selector), self.delegate);
}

#pragma mark - Private Class methods


@end
