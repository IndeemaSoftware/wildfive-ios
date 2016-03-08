//
//  EEPlayer_hidden.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEPlayer.h"
#import "EEGameCommon.h"

@interface EEPlayer ()

- (instancetype)initWithName:(NSString*)playerName type:(EEPlayerType)playerType;
- (void)setPlayerName:(NSString*)playerName;
- (void)setPlayerType:(EEPlayerType)playerType;

@end
