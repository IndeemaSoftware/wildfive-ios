//
//  NSValue+GameLogicStructures.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@interface NSValue (GameLogicStructures)

+ (instancetype)valueWithEEBoardSize:(EEBoardSize)boardSize;
@property (readonly) EEBoardSize boardSize;

+ (instancetype)valueWithEEBoardPoint:(EEBoardPoint)point;
@property (readonly) EEBoardPoint boardPoint;

@end
