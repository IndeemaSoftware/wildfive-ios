//
//  EEBotGameController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBotGameController.h"
#import "EEGameController_hidden.h"
#import "EEBot.h"

@interface EEBotGameController() {
    EEBot *_bot;
    
    NSTimer *_timer;
}

- (void)startTimer;
- (void)stopTimer;

- (void)makeMoveForBot;

+ (NSArray*)getWeightsArrayForBotlevel:(EEBotLevel)botLevel;
+ (NSString*)getBotNameForBotlevel:(EEBotLevel)botLevel;

@end

@implementation EEBotGameController

#pragma mark - Public methods
- (instancetype)initWithBotLevel:(EEBotLevel)level {
    self = [super initGameController];
    if (self) {
        _botLevel = level;
        
        _player = [[EEPlayer alloc] initWithName:NSLocalizedString(@"You", nil) type:EEPlayerTypeX];
        _opponentPlayer = [[EEPlayer alloc] initWithName:[EEBotGameController getBotNameForBotlevel:_botLevel] type:EEPlayerTypeO];
        
        _bot = [[EEBot alloc] initWithLevel:_botLevel board:nil botPlayerType:_opponentPlayer];
        
        [self resetGame];
    }
    return self;
}

- (void)resetGame {
    [self stopTimer];
    
    [super resetGame];
    
    _boardSize = EEBoardSizeMake(19, 19);
    _board = [[EEBoard alloc] initWithBoardSize:_boardSize positionWeights:[EEBotGameController getWeightsArrayForBotlevel:_botLevel]];
    
    _bot.board = _board;
}

- (void)stopGame {
    [self stopBot];
}

- (EEMoveStatus)makeMove:(EEMove *)move {
    EEMoveStatus lMoveStatus = [super makeMove:move];
    
    if (lMoveStatus == EEMoveStatusSuccess) {
        [self startBot];
    }
    
    return lMoveStatus;
}

- (void)startBot {
    if ([self isOpponentPlayerActive] && [self isGameActive]) {
        [self startTimer];
    }
}

- (void)stopBot {
    [self stopTimer];
}

#pragma mark - Private methods
- (void)startTimer {
    [self stopTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(makeMoveForBot) userInfo:nil repeats:NO];
}

- (void)stopTimer {
    if (_timer != nil) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)makeMoveForBot {
    EEBoardPoint lPoint = [_bot findBestNextPosition];
    EEBoardSign lBoardSign = (self.opponentPlayer.type == EEPlayerTypeX) ? EEBoardSignX : EEBoardSignO;
    
    EEMove *lMove = [EEMove moveWithForPlayer:self.opponentPlayer sign:lBoardSign point:lPoint];
    
    [self makeMove:lMove];
}

+ (NSArray*)getWeightsArrayForBotlevel:(EEBotLevel)botLevel {
    switch (botLevel) {
        case EEBotEasy:
            return @[@(3), @(5), @(10), @(20), @(21), @(60), @(5)];
        case EEBotMedium:
            return @[@(4), @(5), @(7), @(20), @(21), @(65), @(2)];
        case EEBotHard:
            return @[@(0), @(0), @(4), @(20), @(100), @(500), @(0)];
        default:
            return @[@(4), @(5), @(7), @(20), @(21), @(65), @(2)];
    }
}

+ (NSString*)getBotNameForBotlevel:(EEBotLevel)botLevel {
    switch (botLevel) {
        case EEBotEasy:
            return NSLocalizedString(@"Mr. Easy", nil);
        case EEBotMedium:
            return NSLocalizedString(@"Mr. Medium", nil);
        case EEBotHard:
            return NSLocalizedString(@"Mr. Hard", nil);
        default:
            return NSLocalizedString(@"Mr. Medium", nil);
    }
}

@end
