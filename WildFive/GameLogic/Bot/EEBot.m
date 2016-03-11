//
//  EEBot.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/11/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBot.h"

#import "EEBoard.h"
#import "EEBoardItem.h"
#import "EEPlayer.h"

@interface EEBot() {
}

+ (NSUInteger)attackFactorForBotLevel:(EEBotLevel)botLevel;

@end

@implementation EEBot

#pragma mark - Public methods
- (instancetype)initWithLevel:(EEBotLevel)level board:(EEBoard*)board botPlayerType:(EEPlayer*)botPlayer {
    self = [super init];
    if (self) {
        _level = level;
        
        _board = board;
        _botPlayer = botPlayer;
    }
    return self;
}

- (EEBoardPoint)findBestNextPositionForBot {
    return [self findBestPositionForPlayer:_botPlayer.type withAttackFactor:[EEBot attackFactorForBotLevel:_level]];
}

- (EEBoardPoint)findBestPositionForPlayer:(EEPlayerType)playerType withAttackFactor:(NSUInteger)attackFactor {
    EEBoardPoint lResult = EEBoardPointMake(1, 1);
    
    EEPlayerType lOpponentPlayer = EEOppositePlayerTo(playerType);
    CGFloat lMaxValue = CGFLOAT_MIN;
    CGFloat lAttackValue = (16.0f + attackFactor) / 16.0f;
    BOOL lIsAllEmpty = YES;
    
    for (NSUInteger x = 0; x < _board.boardSize.width; x++) {
        for (NSUInteger y = 0; y < _board.boardSize.height; y++) {
            EEBoardItem *lBoardItem = [_board itemAtPoint:EEBoardPointMake(x, y)];
            
            if (lBoardItem.playerType == EEPlayerTypeNone) {
                CGFloat lValue = floorf([lBoardItem positionValueForPlayer:playerType] * lAttackValue) + [lBoardItem positionValueForPlayer:lOpponentPlayer];
                
                if (lValue > lMaxValue) {
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

#pragma mark - Privat methods
- (EEBoardPoint)randomPositionForCurrentBoard {
    if (_board.boardSize.width > 11 && _board.boardSize.height > 11) {
        return EEBoardPointMake((int)roundf(_board.boardSize.width / 4.0f) + arc4random() % (int)roundf(_board.boardSize.width / 2.0f), (int)roundf(_board.boardSize.width / 4.0f) + arc4random() % (int)roundf(_board.boardSize.width / 2.0f));
    } else {
        return EEBoardPointMake(arc4random() % _board.boardSize.width, arc4random() % _board.boardSize.height);
    }
}

+ (NSUInteger)attackFactorForBotLevel:(EEBotLevel)botLevel {
    switch (botLevel) {
        case EEBotEasy:
            return 1;
        case EEBotMedium:
            return  2;
        case EEBotHard:
            return 4;
        default:
            return 2;
    }
}

@end
