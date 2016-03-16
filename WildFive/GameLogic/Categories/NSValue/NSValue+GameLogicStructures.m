//
//  NSValue+GameLogicStructures.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "NSValue+GameLogicStructures.h"

@implementation NSValue (GameLogicStructures)

//  - - - - - - - - - - - - EEBoardPoint - - - - - - - - - - - - - -
+ (instancetype)valueWithEEBoardSize:(EEBoardSize)boardSize {
    return [self valueWithBytes:&boardSize objCType:@encode(EEBoardSize)];
}

- (EEBoardSize)boardSize {
    EEBoardSize lBoardSize;
    [self getValue:&lBoardSize];
    return lBoardSize;
}

// - - - - - - - - - - - - EEBoardPoint - - - - - - - - - - - - - -
+ (instancetype)valueWithEEBoardPoint:(EEBoardPoint)point {
    return [self valueWithBytes:&point objCType:@encode(EEBoardPoint)];
}

- (EEBoardPoint)boardPoint {
    EEBoardPoint lBoardPoint;
    [self getValue:&lBoardPoint];
    return lBoardPoint;
}

@end
