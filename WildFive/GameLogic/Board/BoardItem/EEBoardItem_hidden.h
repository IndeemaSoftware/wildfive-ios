//
//  EEBoardItem_hidden.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/11/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoardItem.h"

@interface EEBoardItem () <NSCoding, NSCopying>

- (void)copyDataFromItem:(EEBoardItem*)item;

// 
- (void)setBoardSignValue:(EEBoardSign)boardSign;
- (void)setPlayerTypeValue:(EEPlayerType)playerType;

// lines
- (NSMutableArray*)lineArrayForPlayer:(EEPlayerType)playerType;

- (NSUInteger)lineValueForPlayer:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;
- (void)setLineValue:(NSUInteger)value player:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;
- (void)addToLineValue:(NSUInteger)value player:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;
- (NSUInteger)increamentLineValueForPlayer:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;

// position value
- (void)addPpositionValue:(NSUInteger)value forPlayer:(EEPlayerType)playerType;

@end
