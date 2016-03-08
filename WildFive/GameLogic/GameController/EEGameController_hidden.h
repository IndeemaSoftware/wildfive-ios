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
#import "EEPlayer_hidden.h"

@interface EEGameController ()  {
    @public
    EEBoard *_board;
    
    EEBoardSize _boardSize;
    
    EEPlayer *_player;
    EEPlayer *_opponentPlayer;
    EEPlayer *_activePlayer;
    
    NSUInteger _totalLines;
    
    @private
}

- (void)initializeGameWithDefaulValues;
- (void)changeActivePlayer;

- (EEPutStatus)putValuesForPlayer:(EEPlayer*)player atPoint:(EEBoardPoint)point;
- (void)updateLineValuesForPlayer:(EEPlayer*)player atPoint:(EEBoardPoint)point;

+ (BOOL)isPoint:(EEBoardPoint)point insideBoardSize:(EEBoardSize)boardSize;
+ (NSUInteger)totalLinsForBoardSize:(EEBoardSize)boardSize;
@end
