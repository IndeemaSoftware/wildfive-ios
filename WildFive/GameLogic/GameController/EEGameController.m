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
    self = [super init];
    if (self) {
        [self initializeGameWithDefaulValues];
    }
    return self;
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
    return [EEGameController isPoint:point insideBoardSize:_boardSize];
}

- (BOOL)isBoardFreeAtPoint:(EEBoardPoint)point {
    if ([self isPointInsideGameBoardSize:point]) {
        return NO;
    } else {
        return [_board itemAtPoint:point].boardSign == EEBoardSignNone;
    }
}

- (BOOL)isActionAllowedForPlayer {
    return (_activePlayer.type == _player.type);
}

- (void)resetGame {
    _activePlayer = _player;
    
    _board = [[EEBoard alloc] initWithBoardSize:_boardSize];
    
    _totalLines = [EEGameController totalLinsForBoardSize:_boardSize];
}

- (EEPutStatus)putValuesForPlayerAtPoint:(EEBoardPoint)point {
    return [self putValuesForPlayer:_player atPoint:point];
}

- (EEPutStatus)putValuesForActivePlayerAtPoint:(EEBoardPoint)point {
    return [self putValuesForPlayer:_activePlayer atPoint:point];
}

#pragma mark - Private methods
- (void)initializeGameWithDefaulValues {
    _player = [[EEPlayer alloc] initWithName:NSLocalizedString(@"Player 1", nil) type:EEPlayerTypeX];
    _opponentPlayer = [[EEPlayer alloc] initWithName:NSLocalizedString(@"Player 2", nil) type:EEPlayerTypeO];
    _activePlayer = _player;
    
    _boardSize = EEBoardSizeMake(19, 19);
    
    _board = [[EEBoard alloc] initWithBoardSize:_boardSize];
}

- (void)changeActivePlayer {
    if (_activePlayer.type == _player.type) {
        _activePlayer = _opponentPlayer;
    } else {
        _activePlayer = _player;
    }
    
    [self.delegate EEGameController:self activePlayerHasChanged:_activePlayer];
}

- (EEPutStatus)putValuesForPlayer:(EEPlayer*)player atPoint:(EEBoardPoint)point {
    // check if point is inside the board
    if (![self isPointInsideGameBoardSize:point]) {
        return EEPutStatusIsPointOutsideTheBoard;
    }
    
    // get board item
    EEBoardItem *lBoardItem = [_board itemAtPoint:point];
    
    // check if point is free
    if (lBoardItem.boardSign != EEBoardSignNone) {
        return EEPutStatusIsPointBusy;
    }
    
    // update board value
    lBoardItem.playerType = player.type;
    if (player.type == EEPlayerTypeX) {
        lBoardItem.boardSign = EEBoardSignX;
    } else {
        lBoardItem.boardSign = EEBoardSignO;
    }
    
    //notifi delegate about update in board
    [self.delegate EEGameController:self updateCellAtPoint:point];
    
    // update lines values
    
    // check if we have winner
    
    // check for available turns
    
    // update position values
    
    [self changeActivePlayer];
    
    return EEPutStatusuccess;
}

- (void)updateLineValuesForPlayer:(EEPlayer*)player atPoint:(EEBoardPoint)point {
    EEPlayerType lPlayerType = player.type;
    
    for (NSUInteger offset = 0; offset < 5; offset++) {
        // direction - from left to right ---------------------------------
        EEBoardPoint lCurrentPoint = EEBoardPointMake(point.x - offset, point.y);
        
        if ([self isPointInsideGameBoardSize:lCurrentPoint]) {
            EEBoardItem *lItem = [_board itemAtPoint:lCurrentPoint];
            [lItem increamentLineValueForPlayer:lPlayerType direction:EELineDirectionH];
            
            if (1 == [lItem lineValueForPlayer:lPlayerType direction:EELineDirectionH]) {
                _totalLines--;
            }
        }
        
        
        //from left top to bottom right ---------------------------------
        lCurrentPoint = EEBoardPointMake(point.x - offset, point.y - offset);
        
        if ([self isPointInsideGameBoardSize:lCurrentPoint]) {
            EEBoardItem *lItem = [_board itemAtPoint:lCurrentPoint];
            [lItem increamentLineValueForPlayer:lPlayerType direction:EELineDirectionHVR];
            
            if (1 == [lItem lineValueForPlayer:lPlayerType direction:EELineDirectionHVR]) {
                _totalLines--;
            }
        }
        
        
        // direction - from right top to bottom left  ---------------------------------
        lCurrentPoint = EEBoardPointMake(point.x + offset, point.y - offset);
        
        if ([self isPointInsideGameBoardSize:lCurrentPoint]) {
            EEBoardItem *lItem = [_board itemAtPoint:lCurrentPoint];
            [lItem increamentLineValueForPlayer:lPlayerType direction:EELineDirectionHVL];
            
            if (1 == [lItem lineValueForPlayer:lPlayerType direction:EELineDirectionHVL]) {
                _totalLines--;
            }
        }
        
        
        // direction - from top to bottom  ---------------------------------
        lCurrentPoint = EEBoardPointMake(point.x, point.y - offset);
        
        if ([self isPointInsideGameBoardSize:lCurrentPoint]) {
            EEBoardItem *lItem = [_board itemAtPoint:lCurrentPoint];
            [lItem increamentLineValueForPlayer:lPlayerType direction:EELineDirectionV];
            
            if (1 == [lItem lineValueForPlayer:lPlayerType direction:EELineDirectionV]) {
                _totalLines--;
            }
        }
    }
}

#pragma mark - Private Class methods
+ (BOOL)isPoint:(EEBoardPoint)point insideBoardSize:(EEBoardSize)boardSize {
    return (point.x < boardSize.width) && (point.y < boardSize.height);
}

+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize {
    NSInteger lMinWidth = boardSize.width - 4;
    NSInteger lMinHeight = boardSize.height - 4;
    return 2 * (boardSize.width * lMinHeight + boardSize.height * lMinWidth + 2 * (lMinWidth * lMinHeight));
}

@end
