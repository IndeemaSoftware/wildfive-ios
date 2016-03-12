//
//  EEBoard.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoard.h"
#import "EEBoardItem.h"
#import "EEMove.h"
#import "EEPlayer.h"
#import "EEBoardItem_hidden.h"

// categories
#import "NSValue+GameLogicStructures.h"

typedef struct  {
    EEBoardPoint movePoint;
    EEBoardPoint bottomOffsetPoint;
    EEBoardPoint topOffsetPoint;
    EEPlayerType playerType;
    EEPlayerType opponentPlayerType;
    EELineDirection lineDirection;
    NSUInteger offset;
} EEUpdateValuesData;

// coding keys
#define BOARD_SIZE_K @"board_size"
#define TOTAL_LINES_K @"total_lines"
#define POSITION_WEIGHTS_K @"position_weights"
#define BOARD_ARRAY_K @"board_array"


@interface EEBoard() {
    NSMutableArray *_boardArray;
    
    NSInteger _totalLines;
}

@property (nonatomic, readonly) NSMutableArray *boardArray;

- (void)updateValuesForPlayerType:(EEPlayerType)playerType atPoint:(EEBoardPoint)point;
- (void)updateValuesWithData:(EEUpdateValuesData)updateValuesData;

- (EEFinishResult)checkForWinnerForPlayerType:(EEPlayerType)playerType atPoint:(EEBoardPoint)point direction:(EELineDirection)direction;

// copy
- (void)copyDataFromBoard:(EEBoard*)board;

@end

@implementation EEBoard

#pragma mark - Public methods
- (instancetype)initWithBoardSize:(EEBoardSize)boardSize positionWeights:(NSArray*)positionWeights {
    self = [super init];
    if (self) {
        NSAssert(((boardSize.width >= 10) && (boardSize.height >= 10)), @"EEBoard. Board min size should be: 10x10");
        
        _boardSize = boardSize;
        _totalLines = [EEBoard totalLinsForBoardSize:_boardSize];
        
        _positionWeights = positionWeights;
        
        _boardArray = [[NSMutableArray alloc] init];
        
        for (NSUInteger x = 0; x < _boardSize.width; x++) {
            NSMutableArray *lBoardXArray = [[NSMutableArray alloc] init];
            
            for (NSUInteger y = 0; y < _boardSize.height; y++) {
                [lBoardXArray addObject:[EEBoardItem new]];
            }
            
            [_boardArray addObject:lBoardXArray];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _boardSize = [(NSValue*)[aDecoder decodeObjectForKey:BOARD_SIZE_K] boardSize];
        _totalLines = [aDecoder decodeIntegerForKey:TOTAL_LINES_K];
        
        _positionWeights = [aDecoder decodeObjectForKey:POSITION_WEIGHTS_K];
        _boardArray = [aDecoder decodeObjectForKey:BOARD_ARRAY_K];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSValue valueWithEEBoardSize:_boardSize] forKey:BOARD_SIZE_K];
    [aCoder encodeInteger:_totalLines forKey:TOTAL_LINES_K];
    [aCoder encodeObject:_positionWeights forKey:POSITION_WEIGHTS_K];
    [aCoder encodeObject:_boardArray forKey:BOARD_ARRAY_K];
}

- (id)copyWithZone:(NSZone *)zone {
    EEBoard *lBoardCopy = [[[self class] alloc] init];
    [lBoardCopy copyDataFromBoard:self];
    return lBoardCopy;
}

#pragma mark Items
- (EEBoardItem*)itemAtPoint:(EEBoardPoint)boardPoint {
    return _boardArray[boardPoint.x][boardPoint.y];
}

- (EEBoardItem*)firstItem {
    return _boardArray[0][0];
}

- (EEBoardItem*)lastItem {
    return _boardArray[_boardSize.width-1][_boardSize.height-1];
}

- (BOOL)hasFreeItems {
    for (NSUInteger x = 0; x < _boardSize.width; x++) {
        for (NSUInteger y = 0; y < _boardSize.height; y++) {
            if ([self itemAtPoint:EEBoardPointMake(x, y)].playerType == EEPlayerTypeNone) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark Updates
- (EEMoveStatus)updateBoardValuesWithMove:(EEMove *)move {
    // check if point is inside the board
    if (!EEBoardPointIsInsideBoard(move.point, _boardSize)) {
        return EEMoveStatusIsPointOutsideTheBoard;
    }
    
    // get board item
    EEBoardItem *lBoardItem = [self itemAtPoint:move.point];
    
    // check if point is free
    if (lBoardItem.boardSign != EEBoardSignNone) {
        return EEMoveStatusIsPointBusy;
    }
    
    // update board value
    [lBoardItem setBoardSignValue:move.boardSign];
    [lBoardItem setPlayerTypeValue:move.player.type];
    
    // update values
    [self updateValuesForPlayerType:move.player.type atPoint:move.point];
    
    return EEMoveStatusSuccess;
}

- (EEFinishResult)checkForWinner {
    EEFinishResult lWinResult;
    lWinResult.hasWinner = NO;

    NSUInteger lTempLineValue = 0;
    
    for (NSUInteger x = 0; x < _boardSize.width; x++) {
        for (NSUInteger y = 0; y < _boardSize.height; y++) {
            EEBoardItem *lItem = [self itemAtPoint:EEBoardPointMake(x, y)];
            
            for (EEPlayerType player = EEPlayerTypeX ; player <= EEPlayerTypeO; player++) {
                for (EELineDirection lineDirection = EELineDirectionH ; lineDirection <= EELineDirectionV; lineDirection++) {
                    
                    lTempLineValue = [lItem lineValueForPlayer:player direction:lineDirection];
                    if (lTempLineValue >= 5) {
                        lWinResult.hasWinner = YES;
                        lWinResult.playerType = player;
                        lWinResult.startPoint = EEBoardPointMake(x, y);
                        lWinResult.lineDirection = lineDirection;
                        lWinResult.lineLenght = lTempLineValue;
                        
                        return lWinResult;
                    }
                }
            }
        }
    }
    
    return lWinResult;
}

- (EEFinishResult)checkForWinnerForMove:(EEMove*)move {
    EEFinishResult lWinResult;
    lWinResult.hasWinner = NO;
    
    EEBoardPoint lTempPoint = move.point;
    
    EEPlayerType lPlayerType = move.player.type;
    EEBoardPoint lBottomOffsetPoint = EEBoardPointMake(4, 4);
    EEBoardPoint lTopOffsetPoint = EEBoardPointMake(_boardSize.width - 4, _boardSize.height - 4);
    
    for (NSInteger offset = 4; offset >= 0; offset--) {
        for (EELineDirection lineDirection = EELineDirectionH; lineDirection <= EELineDirectionHVL; lineDirection++) {
            
            BOOL lIsInsideBoard = NO;
            
            if (lineDirection == EELineDirectionH) {
                lTempPoint = EEBoardPointMake(move.point.x - offset, move.point.y);
                lIsInsideBoard = ((lTempPoint.x >= 0) && (lTempPoint.x < lTopOffsetPoint.x));
                
            } else if (lineDirection == EELineDirectionHVR) {
                lTempPoint = EEBoardPointMake(move.point.x - offset, move.point.y - offset);
                lIsInsideBoard = ((lTempPoint.x >= 0) && (lTempPoint.x < lTopOffsetPoint.x) && (lTempPoint.y >= 0) && (lTempPoint.y < lTopOffsetPoint.y));
                
            } else if (lineDirection == EELineDirectionHVL) {
                lTempPoint = EEBoardPointMake(move.point.x + offset, move.point.y - offset);
                lIsInsideBoard = ((lTempPoint.x >= lBottomOffsetPoint.x) && (lTempPoint.x < _boardSize.width) && (lTempPoint.y >= 0) && (lTempPoint.y < lTopOffsetPoint.y));
                
            } else if (lineDirection == EELineDirectionV) {
                lTempPoint = EEBoardPointMake(move.point.x, move.point.y - offset);
                lIsInsideBoard = ((lTempPoint.y >= 0) && (lTempPoint.y < lTopOffsetPoint.y));
            }
            
            if (!lIsInsideBoard) {
                continue;
            }
            
            lWinResult = [self checkForWinnerForPlayerType:lPlayerType atPoint:lTempPoint direction:lineDirection];
            if (lWinResult.hasWinner) {
                return lWinResult;
            }
        }
    }
    
    return lWinResult;
}

#pragma mark - Private methods
- (void)updateValuesForPlayerType:(EEPlayerType)playerType atPoint:(EEBoardPoint)point {
    EEUpdateValuesData lUpdateValuesData;
    lUpdateValuesData.playerType = playerType;
    lUpdateValuesData.opponentPlayerType = EEOppositePlayerTo(playerType);
    lUpdateValuesData.movePoint = point;
    lUpdateValuesData.bottomOffsetPoint = EEBoardPointMake(4, 4);
    lUpdateValuesData.topOffsetPoint = EEBoardPointMake(_boardSize.width - 4, _boardSize.height - 4);
    
    for (NSUInteger offset = 0; offset < 5; offset++) {
        for (EELineDirection lineDirection = EELineDirectionH; lineDirection <= EELineDirectionHVL; lineDirection++) {
            lUpdateValuesData.offset = offset;
            lUpdateValuesData.lineDirection = lineDirection;
            [self updateValuesWithData:lUpdateValuesData];
        }
    }
}

- (void)updateValuesWithData:(EEUpdateValuesData)updateValuesData {
    EEBoardPoint lTempPoint = updateValuesData.movePoint;
    EEBoardPoint lRecursiveOffset;
    BOOL lIsInsideBoard = NO;
    
    if (updateValuesData.lineDirection == EELineDirectionH) {
        lTempPoint = EEBoardPointMake(updateValuesData.movePoint.x - updateValuesData.offset, updateValuesData.movePoint.y);
        lRecursiveOffset = EEBoardPointMake(1, 0);
        lIsInsideBoard = (lTempPoint.x >= 0) && (lTempPoint.x < updateValuesData.topOffsetPoint.x);
        
    } else if (updateValuesData.lineDirection == EELineDirectionHVR) {
        lTempPoint = EEBoardPointMake(updateValuesData.movePoint.x - updateValuesData.offset, updateValuesData.movePoint.y - updateValuesData.offset);
        lRecursiveOffset = EEBoardPointMake(1, 1);
        lIsInsideBoard = (lTempPoint.x >= 0) && (lTempPoint.x < updateValuesData.topOffsetPoint.x) && (lTempPoint.y >= 0) && (lTempPoint.y < updateValuesData.topOffsetPoint.y);
        
    } else if (updateValuesData.lineDirection == EELineDirectionHVL) {
        lTempPoint = EEBoardPointMake(updateValuesData.movePoint.x + updateValuesData.offset, updateValuesData.movePoint.y - updateValuesData.offset);
        lRecursiveOffset = EEBoardPointMake(-1, 1);
        lIsInsideBoard = (lTempPoint.x >= updateValuesData.bottomOffsetPoint.x) && (lTempPoint.x < _boardSize.width) && (lTempPoint.y >= 0) && (lTempPoint.y < updateValuesData.topOffsetPoint.y);
        
    } else if (updateValuesData.lineDirection == EELineDirectionV) {
        lTempPoint = EEBoardPointMake(updateValuesData.movePoint.x, updateValuesData.movePoint.y - updateValuesData.offset);
        lRecursiveOffset = EEBoardPointMake(0, 1);
        lIsInsideBoard = (lTempPoint.y >= 0) && (lTempPoint.y < updateValuesData.topOffsetPoint.y);
    }
    
    if (!lIsInsideBoard) {
        return;
    }
    
    EEBoardItem *lItem = [self itemAtPoint:lTempPoint];
    
    NSUInteger lLineValue = [lItem increamentLineValueForPlayer:updateValuesData.playerType direction:updateValuesData.lineDirection];
    if (1 == lLineValue) {
        _totalLines--;
    }
    
    // update position values if weights array is available
    if (_positionWeights != nil) {
        NSUInteger lOpponentLineValue = [lItem lineValueForPlayer:updateValuesData.opponentPlayerType direction:updateValuesData.lineDirection];
        NSInteger lNewPositionValue = 0;
        
        if (0 == lOpponentLineValue) {
            lNewPositionValue = [(NSNumber*)_positionWeights[lLineValue + 1] integerValue] - [(NSNumber*)_positionWeights[lLineValue] integerValue];
        } else if (1 == lLineValue) {
            lNewPositionValue = -[(NSNumber*)_positionWeights[lOpponentLineValue + 1] integerValue];
        }
        
        // update position values
        for (NSUInteger recursiveOffset = 0; recursiveOffset < 5; recursiveOffset++) {
            EEBoardPoint lOffsetPoint = EEBoardPointMake(lTempPoint.x + recursiveOffset * lRecursiveOffset.x, lTempPoint.y + recursiveOffset * lRecursiveOffset.y);
            
            if (0 == lOpponentLineValue) {
                lItem = [self itemAtPoint:lOffsetPoint];
                [lItem addPpositionValue:lNewPositionValue forPlayer:updateValuesData.playerType];
            } else if (1 == lLineValue) {
                lItem = [self itemAtPoint:lOffsetPoint];
                [lItem addPpositionValue:lNewPositionValue forPlayer:updateValuesData.opponentPlayerType];
            }
        }
    }
}

- (EEFinishResult)checkForWinnerForPlayerType:(EEPlayerType)playerType atPoint:(EEBoardPoint)point direction:(EELineDirection)direction {
    EEFinishResult lFinishResult;
    lFinishResult.hasWinner = NO;
    
    EEBoardItem *lItem = [self itemAtPoint:point];
    
    NSUInteger lLineValue = [lItem lineValueForPlayer:playerType direction:direction];
    
    if (5 <= lLineValue) {
        lFinishResult.hasWinner = YES;
        lFinishResult.playerType = playerType;
        lFinishResult.startPoint = point;
        lFinishResult.lineDirection = direction;
        lFinishResult.lineLenght = lLineValue;
    }
    
    return lFinishResult;
}

- (void)copyDataFromBoard:(EEBoard*)board {
    _boardSize = board.boardSize;
    _totalLines = board.totalLines;
    _positionWeights = board.positionWeights;
    
    _boardArray = [board.boardArray copy];
}

#pragma mark - Utils
+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize {
    NSInteger lMinWidth = boardSize.width - 4;
    NSInteger lMinHeight = boardSize.height - 4;
    return 2 * (boardSize.width * lMinHeight + boardSize.height * lMinWidth + 2 * (lMinWidth * lMinHeight));
}

@end
