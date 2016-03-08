//
//  EEBoard.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoard.h"
#import "EEBoardItem.h"

@interface EEBoard() {
    NSMutableArray *_boardArray;
    
    NSInteger _totalLines;
}

+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize;

@end

@implementation EEBoard

#pragma mark - Public methods
- (instancetype)initWithBoardSize:(EEBoardSize)boardSize {
    self = [super init];
    if (self) {
        _boardSize = boardSize;
        _totalLines = [EEBoard totalLinsForBoardSize:_boardSize];
        
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

- (EEBoardItem*)itemAtPoint:(EEBoardPoint)boardPoint {
    return _boardArray[boardPoint.x][boardPoint.y];
}

- (EEBoardItem*)firstItem {
    return _boardArray[0][0];
}

- (EEBoardItem*)lastItem {
    return _boardArray[_boardSize.width-1][_boardSize.height-1];
}

#pragma mark - Private methods
+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize {
    NSInteger lMinWidth = boardSize.width - 4;
    NSInteger lMinHeight = boardSize.height - 4;
    return 2 * (boardSize.width * lMinHeight + boardSize.height * lMinWidth + 2 * (lMinWidth * lMinHeight));
}

@end
