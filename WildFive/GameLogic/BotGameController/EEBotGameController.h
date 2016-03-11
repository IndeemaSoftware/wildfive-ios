//
//  EEBotGameController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameController.h"

@interface EEBotGameController : EEGameController

@property (nonatomic, readonly) EEBotLevel botLevel;

- (instancetype)initWithBotLevel:(EEBotLevel)level;

- (void)startBot;
- (void)stopBot;

@end
