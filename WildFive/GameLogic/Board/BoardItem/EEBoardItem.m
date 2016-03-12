//
//  EEBoardItem.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoardItem.h"
#import "EEBoardItem_hidden.h"

// decode values
#define BOARD_SIGN @"board_sign"
#define PLAYER_TYPE @"player_type"

#define PLAYER_X_LINE_ARRAY @"player_x_line_array"
#define PLAYER_O_LINE_ARRAY @"player_o_line_array"

#define PLAYER_X_POSITION_VALUE @"player_x_position_value"
#define PLAYER_O_POSITION_VALUE @"player_o_position_value"

@interface EEBoardItem() {
    NSMutableArray *_playerXLineArr;
    NSMutableArray *_playerOLineArr;
    
    NSUInteger _playerXPositionValue;
    NSUInteger _playerOPositionValue;
}

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _boardSign = [aDecoder decodeIntegerForKey:BOARD_SIGN];
        _playerType = [aDecoder decodeIntegerForKey:PLAYER_TYPE];
        
        _playerXLineArr = [aDecoder decodeObjectForKey:PLAYER_X_LINE_ARRAY];
        _playerOLineArr = [aDecoder decodeObjectForKey:PLAYER_O_LINE_ARRAY];
        
        _playerXPositionValue = (NSUInteger)[aDecoder decodeInt64ForKey:PLAYER_X_POSITION_VALUE];
        _playerOPositionValue = (NSUInteger)[aDecoder decodeInt64ForKey:PLAYER_O_POSITION_VALUE];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_boardSign forKey:BOARD_SIGN];
    [aCoder encodeInteger:_playerType forKey:PLAYER_TYPE];
    
    [aCoder encodeObject:_playerXLineArr forKey:PLAYER_X_LINE_ARRAY];
    [aCoder encodeObject:_playerOLineArr forKey:PLAYER_O_LINE_ARRAY];
    
    [aCoder encodeInt64:_playerXPositionValue forKey:PLAYER_X_POSITION_VALUE];
    [aCoder encodeInt64:_playerOPositionValue forKey:PLAYER_O_POSITION_VALUE];
}


- (NSUInteger)positionValueForPlayer:(EEPlayerType)playerType {
    if (playerType == EEPlayerTypeX) {
        return _playerXPositionValue;
    } else {
        return _playerOPositionValue;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    EEBoardItem *lItemCopy = [[EEBoardItem alloc] init];
    if (lItemCopy) {
        [lItemCopy copyDataFromItem:self];
    }
    
    return lItemCopy;
}

- (NSString *)description {
    if (_boardSign == EEBoardSignX) {
        return @"X";
    } else if (_boardSign == EEBoardSignO) {
        return @"O";
    } else {
        return @" ";
    }
}

#pragma mark - Private methods
- (void)copyDataFromItem:(EEBoardItem*)item {
    _boardSign = item.boardSign;
    _playerType = item.playerType;
    
    _playerXLineArr = [[item lineArrayForPlayer:EEPlayerTypeX] copy];
    _playerOLineArr = [[item lineArrayForPlayer:EEPlayerTypeO] copy];
    
    _playerXPositionValue = [item positionValueForPlayer:EEPlayerTypeX];
    _playerOPositionValue = [item positionValueForPlayer:EEPlayerTypeO];
}


- (void)setBoardSignValue:(EEBoardSign)boardSign {
    _boardSign = boardSign;
}

- (void)setPlayerTypeValue:(EEPlayerType)playerType {
    _playerType = playerType;
}

- (NSMutableArray*)lineArrayForPlayer:(EEPlayerType)playerType {
    if (playerType == EEPlayerTypeX) {
        return _playerXLineArr;
    } else {
        return _playerOLineArr;
    }
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

@end
