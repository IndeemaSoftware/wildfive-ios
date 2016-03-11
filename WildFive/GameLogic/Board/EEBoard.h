//
//  EEBoard.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@class EEBoardItem;
@class EEMove;

@interface EEBoard : NSObject

@property (nonatomic, readonly) EEBoardSize boardSize;
@property (nonatomic, readonly) NSInteger totalLines;

@property (nonatomic, readonly) NSArray *positionWeights;

- (instancetype)initWithBoardSize:(EEBoardSize)boardSize positionWeights:(NSArray*)positionWeights;

// Items
- (EEBoardItem*)itemAtPoint:(EEBoardPoint)boardPoint;
- (EEBoardItem*)firstItem;
- (EEBoardItem*)lastItem;
- (BOOL)hasFreeItems;

// Updates
- (EEMoveStatus)updateBoardValuesWithMove:(EEMove*)move;

// winner
- (EEFinishResult)checkForWinner;
- (EEFinishResult)checkForWinnerForMove:(EEMove*)move;

// Utils
+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize;

@end
