//
//  EEBot.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/11/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@class EEBoard;
@class EEPlayer;

@interface EEBot : NSObject

@property (nonatomic, assign) EEBotLevel level;
@property (nonatomic, weak) EEBoard *board;
@property (nonatomic, weak) EEPlayer *botPlayer;

- (instancetype)initWithLevel:(EEBotLevel)level board:(EEBoard*)board botPlayerType:(EEPlayer*)botPlayer;

- (EEBoardPoint)findBestNextPosition;

@end
