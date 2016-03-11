//
//  EEMove.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/10/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEMove.h"
#import "EEPlayer.h"

@implementation EEMove

- (instancetype)initWithForPlayer:(EEPlayer*)player sign:(EEBoardSign)boardSign point:(EEBoardPoint)point {
    self = [super init];
    if (self) {
        _player = player;
        _boardSign = boardSign;
        _point = point;
    }
    return self;
}

+ (EEMove*)moveWithForPlayer:(EEPlayer*)player sign:(EEBoardSign)boardSign point:(EEBoardPoint)point {
    return [[EEMove alloc] initWithForPlayer:player sign:boardSign point:point];
}

@end
