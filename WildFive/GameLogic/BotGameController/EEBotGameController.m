//
//  EEBotGameController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBotGameController.h"
#import "EEGameController_hidden.h"

@interface EEBotGameController() {
    NSArray *_weightArr;
    NSUInteger _attackFactor;
}

- (void)initializeBotDataForLevel:(EEBotLevel)botLevel;
- (EEBoardPoint)findBestNextPositionForBot;
- (EEBoardPoint)findBestPositionForPlayer:(EEPlayerType)playerType withAttackFactor:(NSUInteger)attackFactor;
- (EEBoardPoint)randomPositionForCurrentBoard;

@end

@implementation EEBotGameController

#pragma mark - Public methods
- (instancetype)initWithBotLevel:(EEBotLevel)level {
    self = [super init];
    if (self) {
        _botLevel = level;

        [self initializeBotDataForLevel:_botLevel];
    }
    return self;
}

#pragma mark - Private methods
- (void)initializeBotDataForLevel:(EEBotLevel)botLevel {
    [self.player setPlayerName:NSLocalizedString(@"You", nil)];
    
    switch (botLevel) {
        case EEBotEasy: {
            [self.opponentPlayer setPlayerName:NSLocalizedString(@"Mr. Easy", nil)];
            _attackFactor = 1;
            _weightArr = @[@(3), @(5), @(10), @(20), @(21), @(60), @(5)];
            break;
        }
        case EEBotMedium: {
            [self.opponentPlayer setPlayerName:NSLocalizedString(@"Mr. Medium", nil)];
            _attackFactor = 2;
            _weightArr = @[@(4), @(5), @(7), @(20), @(21), @(65), @(2)];
            break;
        }
        case EEBotHard: {
            [self.opponentPlayer setPlayerName:NSLocalizedString(@"Mr. Hard", nil)];
            _attackFactor = 4;
            _weightArr = @[@(0), @(0), @(4), @(20), @(100), @(500), @(0)];
            break;
        }
        default:
            break;
    }
}

- (EEBoardPoint)findBestNextPositionForBot {
    return [self findBestPositionForPlayer:_opponentPlayer.type withAttackFactor:_attackFactor];
}

- (EEBoardPoint)findBestPositionForPlayer:(EEPlayerType)playerType withAttackFactor:(NSUInteger)attackFactor {
    EEBoardPoint lResult = EEBoardPointMake(1, 1);
    
    EEPlayerType lOpponentPlayer = EEOppositePlayerTo(playerType);
    CGFloat lMaxValue = 0.0f;
    CGFloat lAttackValue = (16.0f + attackFactor) / 16.0f;
    BOOL lIsAllEmpty = YES;
    
    //init first value
    EEBoardItem *lFirstBoardItem = _board.firstItem;
    lMaxValue = floorf([lFirstBoardItem positionValueForPlayer:playerType] * lAttackValue) + [lFirstBoardItem positionValueForPlayer:lOpponentPlayer];
    
    for (NSUInteger x = 0; x < _boardSize.width; x++) {
        for (NSUInteger y = 0; y < _boardSize.height; y++) {
            EEBoardItem *lBoardItem = [_board itemAtPoint:EEBoardPointMake(x, y)];
            
            if (lBoardItem.playerType == EEPlayerTypeNone) {
                CGFloat lValue = floorf([lBoardItem positionValueForPlayer:playerType] * lAttackValue) + [lBoardItem positionValueForPlayer:lOpponentPlayer];
                
                if (lValue >= lMaxValue) {
                    lMaxValue = lValue;
                    lResult = EEBoardPointMake(x, y);
                }
            } else if (lIsAllEmpty) {
                lIsAllEmpty = NO;
            }
        }
    }
    
    DLog(@"lMaxValue %f", lMaxValue);
    if (lIsAllEmpty) {
        lResult = [self randomPositionForCurrentBoard];
    }
    
    return lResult;
}

- (EEBoardPoint)randomPositionForCurrentBoard {
    if (_boardSize.width > 11 && _boardSize.height > 11) {
        return EEBoardPointMake((int)roundf(_boardSize.width / 4.0f) + arc4random() % (int)roundf(_boardSize.width / 2.0f), (int)roundf(_boardSize.width / 4.0f) + arc4random() % (int)roundf(_boardSize.width / 2.0f));
    } else {
        return EEBoardPointMake(arc4random() % _boardSize.width, arc4random() % _boardSize.height);
    }
}

@end
