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

typedef struct  {
    EEBoardPoint movePoint;
    EEBoardPoint bottomOffsetPoint;
    EEBoardPoint topOffsetPoint;
    EEPlayerType playerType;
    EEPlayerType opponentPlayerType;
    EELineDirection lineDirection;
    NSUInteger offset;
} EEUpdateValuesData;




@interface EEBoard() {
    NSMutableArray *_boardArray;
    
    NSInteger _totalLines;
    
    EEBoardSize _linesBoardSize;
}

- (void)updateValuesForPlayerType:(EEPlayerType)playerType atPoint:(EEBoardPoint)point;
- (void)updateValuesWithData:(EEUpdateValuesData)updateValuesData;

- (EEFinishResult)checkForWinnerForPlayerType:(EEPlayerType)playerType atPoint:(EEBoardPoint)point direction:(EELineDirection)direction;

@end

@implementation EEBoard

#pragma mark - Public methods
- (instancetype)initWithBoardSize:(EEBoardSize)boardSize positionWeights:(NSArray*)positionWeights {
    self = [super init];
    if (self) {
        _boardSize = boardSize;
        _totalLines = [EEBoard totalLinsForBoardSize:_boardSize];
        
        _linesBoardSize = EEBoardSizeMake(_boardSize.width - 4, _boardSize.height - 4);
        
        _positionWeights = positionWeights;
        
        _boardArray = [[NSMutableArray alloc] init];
        
        for (NSUInteger x = 0; x < boardSize.width; x++) {
            NSMutableArray *lBoardXArray = [[NSMutableArray alloc] init];
            
            for (NSUInteger y = 0; y < boardSize.height; y++) {
                [lBoardXArray addObject:[EEBoardItem new]];
            }
            
            [_boardArray addObject:lBoardXArray];
        }
    }
    return self;
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
    BOOL lReturn = NO;
    
    for (NSUInteger x = 0; x < _boardSize.width; x++) {
        for (NSUInteger y = 0; y < _boardSize.height; y++) {
            if ([self itemAtPoint:EEBoardPointMake(x, y)].playerType == EEPlayerTypeNone) {
                lReturn = YES;
                break;
            }
        }
    }
    
    return lReturn;
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
                        
                        break;
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
    EEBoardPoint lBottomOffsetPoint = EEBoardPointMake(move.point.x + 4, move.point.y + 4);
    EEBoardPoint lTopOffsetPoint = EEBoardPointMake(_boardSize.width - 4, _boardSize.height - 4);
    
    for (NSInteger offset = 4; offset >= 0; offset--) {
        // direction - from left to right ---------------------------------
        lTempPoint = EEBoardPointMake(move.point.x - offset, move.point.y);
        
        if ((lTempPoint.x >= 0) && (lTempPoint.x < lTopOffsetPoint.x)) {
            lWinResult = [self checkForWinnerForPlayerType:lPlayerType atPoint:lTempPoint direction:EELineDirectionH];
            if (lWinResult.hasWinner) {
                break;
            }
        }
        
        
        //from left top to bottom right ---------------------------------
        lTempPoint = EEBoardPointMake(move.point.x - offset, move.point.y - offset);
        
        if ((lTempPoint.x >= 0) && (lTempPoint.x < lTopOffsetPoint.x) && (lTempPoint.y >= 0) && (lTempPoint.y < lTopOffsetPoint.y)) {
            lWinResult = [self checkForWinnerForPlayerType:lPlayerType atPoint:lTempPoint direction:EELineDirectionHVR];
            if (lWinResult.hasWinner) {
                break;
            }
        }
        
        
        // direction - from right top to bottom left  ---------------------------------
        lTempPoint = EEBoardPointMake(move.point.x + offset, move.point.y - offset);
        
        if ((lTempPoint.x >= lBottomOffsetPoint.x) && (lTempPoint.x < _boardSize.width) && (lTempPoint.y >= 0) && (lTempPoint.y < lTopOffsetPoint.y)) {
            lWinResult = [self checkForWinnerForPlayerType:lPlayerType atPoint:lTempPoint direction:EELineDirectionHVL];
            if (lWinResult.hasWinner) {
                break;
            }
        }
        
        
        // direction - from top to bottom  ---------------------------------
        lTempPoint = EEBoardPointMake(move.point.x, move.point.y - offset);
        
        if ((lTempPoint.y >= 0) && (lTempPoint.y < lTopOffsetPoint.y)) {
            lWinResult = [self checkForWinnerForPlayerType:lPlayerType atPoint:lTempPoint direction:EELineDirectionV];
            if (lWinResult.hasWinner) {
                break;
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
    lUpdateValuesData.bottomOffsetPoint = EEBoardPointMake(point.x + 4, point.y + 4);
    lUpdateValuesData.topOffsetPoint = EEBoardPointMake(_boardSize.width - 4, _boardSize.height - 4);
    
    for (NSUInteger offset = 0; offset < 5; offset++) {
        for (EELineDirection lineDirection = EELineDirectionH; lineDirection <= EELineDirectionV; lineDirection++) {
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
    EEFinishResult lWinResult;
    lWinResult.hasWinner = NO;
    
    EEBoardItem *lItem = [self itemAtPoint:point];
    
    NSUInteger lLineValue = [lItem lineValueForPlayer:playerType direction:direction];
    
    if (5 <= lLineValue) {
        lWinResult.hasWinner = YES;
        lWinResult.playerType = playerType;
        lWinResult.startPoint = point;
        lWinResult.lineDirection = direction;
        lWinResult.lineLenght = lLineValue;
    }
    
    return lWinResult;
}

#pragma mark - Utils
+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize {
    NSInteger lMinWidth = boardSize.width - 4;
    NSInteger lMinHeight = boardSize.height - 4;
    return 2 * (boardSize.width * lMinHeight + boardSize.height * lMinWidth + 2 * (lMinWidth * lMinHeight));
}

@end
