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

- (BOOL)isActionAllowedForPlayer {
    return (_activePlayer.type == _player.type);
}

- (void)resetGame {
    _activePlayer = _player;
    
    _board = [[EEBoard alloc] initWithBoardSize:_boardSize];
}

#pragma mark - Private methods
- (void)initializeGameWithDefaulValues {
    _player = [[EEPlayer alloc] initWithName:NSLocalizedString(@"Player 1", nil) type:EEPlayerTypeX];
    _opponentPlayer = [[EEPlayer alloc] initWithName:NSLocalizedString(@"Player 2", nil) type:EEPlayerTypeO];
    _activePlayer = _player;
    
    _boardSize = EEBoardSizeMake(19, 19);
    
    _board = [[EEBoard alloc] initWithBoardSize:_boardSize];
}

- (BOOL)isPointInsideGameBoardSize:(EEBoardPoint)point {
    return [EEGameController isPoint:point insideBoardSize:_boardSize];
}

#pragma mark - Private Class methods
+ (BOOL)isPoint:(EEBoardPoint)point insideBoardSize:(EEBoardSize)boardSize {
    return (point.x < boardSize.width) && (point.y < boardSize.height);
}

@end
