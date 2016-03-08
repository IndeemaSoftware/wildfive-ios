//
//  EEPlayer.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEPlayer.h"
#import "EEPlayer_hidden.h"

@implementation EEPlayer

- (instancetype)initWithName:(NSString *)playerName type:(EEPlayerType)playerType {
    self = [super init];
    if (self) {
        _name = playerName;
        _type = playerType;
    }
    return self;
}

- (void)setPlayerName:(NSString*)playerName {
    _name = [playerName copy];
}

- (void)setPlayerType:(EEPlayerType)playerType {
    _type = playerType;
}

@end
