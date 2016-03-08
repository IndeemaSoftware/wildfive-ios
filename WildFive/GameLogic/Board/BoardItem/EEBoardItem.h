//
//  EEBoardItem.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@interface EEBoardItem : NSObject

@property (nonatomic, assign) EEBoardSign boardSign;
@property (nonatomic, assign) EEPlayerType playerType;

// lines
- (NSUInteger)lineValueForPlayer:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;
- (void)setLineValue:(NSUInteger)value player:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;
- (void)addToLineValue:(NSUInteger)value player:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;
- (void)increamentLineValueForPlayer:(EEPlayerType)playerType direction:(EELineDirection)lineDirection;

// position value
- (NSUInteger)positionValueForPlayer:(EEPlayerType)playerType;
- (void)addPpositionValue:(NSUInteger)value forPlayer:(EEPlayerType)playerType;

@end
