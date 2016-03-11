//
//  EEBoardItem.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoardItem.h"
#import "EEBoardItem_hidden.h"

@interface EEBoardItem() {
    NSMutableArray *_playerXLineArr;
    NSMutableArray *_playerOLineArr;
    
    NSUInteger _playerXPositionValue;
    NSUInteger _playerOPositionValue;
}

- (NSMutableArray*)lineArrayForPlayer:(EEPlayerType)playerType;

@end

@implementation EEBoardItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _boardSign = EEBoardSignNone;
        _playerType = EEPlayerTypeNone;
        
        _playerXLineArr = [NSMutableArray arrayWithObjects:@(0), @(0), @(0), @(0), nil];
        _playerOLineArr = [NSMutableArray arrayWithObjects:@(0), @(0), @(0), @(0), nil];
        
        _playerXPositionValue = 0;
        _playerOPositionValue = 0;
    }
    
    return self;
}

- (NSUInteger)positionValueForPlayer:(EEPlayerType)playerType {
    if (playerType == EEPlayerTypeX) {
        return _playerXPositionValue;
    } else {
        return _playerOPositionValue;
    }
}

#pragma mark - Private methods

- (void)setBoardSignValue:(EEBoardSign)boardSign {
    _boardSign = boardSign;
}

- (void)setPlayerTypeValue:(EEPlayerType)playerType {
    _playerType = playerType;
}

- (NSUInteger)lineValueForPlayer:(EEPlayerType)playerType direction:(EELineDirection)lineDirection {
    return [(NSNumber*)[self lineArrayForPlayer:playerType][lineDirection] unsignedIntegerValue];
}

- (void)setLineValue:(NSUInteger)value player:(EEPlayerType)playerType direction:(EELineDirection)lineDirection {
    [[self lineArrayForPlayer:playerType] replaceObjectAtIndex:lineDirection withObject:@(value)];
}

- (void)addToLineValue:(NSUInteger)value player:(EEPlayerType)playerType direction:(EELineDirection)lineDirection {
    NSMutableArray *lLineArr = [self lineArrayForPlayer:playerType];
    [lLineArr replaceObjectAtIndex:lineDirection withObject:@(value + [(NSNumber*)lLineArr[lineDirection] unsignedIntegerValue])];
}

- (NSUInteger)increamentLineValueForPlayer:(EEPlayerType)playerType direction:(EELineDirection)lineDirection {
    NSMutableArray *lLineArr = [self lineArrayForPlayer:playerType];
    NSUInteger lNewValue = 1 + [(NSNumber*)lLineArr[lineDirection] unsignedIntegerValue];
    [lLineArr replaceObjectAtIndex:lineDirection withObject:@(lNewValue)];
    
    return lNewValue;
}

- (void)addPpositionValue:(NSUInteger)value forPlayer:(EEPlayerType)playerType {
    if (playerType == EEPlayerTypeX) {
        _playerXPositionValue += value;
    } else {
        _playerOPositionValue += value;
    }
}

- (NSMutableArray*)lineArrayForPlayer:(EEPlayerType)playerType {
    if (playerType == EEPlayerTypeX) {
        return _playerXLineArr;
    } else {
        return _playerOLineArr;
    }
}

@end
