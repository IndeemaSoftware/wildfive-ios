//
//  NSValue+GameLogicStructures.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "NSValue+GameLogicStructures.h"

@implementation NSValue (GameLogicStructures)

+ (instancetype)valueWithEEBoardSize:(EEBoardSize)boardSize {
    return [self valueWithBytes:&boardSize objCType:@encode(EEBoardSize)];
}

- (EEBoardSize)boardSize {
    EEBoardSize lBoardSize;
    [self getValue:&lBoardSize];
    return lBoardSize;
}

@end
