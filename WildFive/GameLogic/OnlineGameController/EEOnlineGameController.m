//
//  EEOnlineGameController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEOnlineGameController.h"
#import "EEGameController_hidden.h"

#import "EEGameConnection.h"
#import "EEGameConnectionDelegate.h"

#import "NSValue+GameLogicStructures.h"

// keys
#define PLAYER_TYPE_O   @"O"
#define PLAYER_TYPE_X   @"X"

#define BOARD_SIGN_O   @"O"
#define BOARD_SIGN_X   @"X"

#define PLAYER_TYPE         @"player_type"
#define BOARD_SIGN          @"board_sign"
#define BOARD_POINT_X       @"board_point_x"
#define BOARD_POINT_Y       @"board_point_y"

#define TYPE_MOVE        @"move"
#define TYPE_MESSAGE     @"message"

#define KEY_DATA        @"data"
#define KEY_TYPE     @"type"

@interface EEOnlineGameController() <EEGameConnectionDelegate> {
    id <EEGameConnection> _gameConnection;
}

- (void)sendToOpponentMessageOfLeavingGame;

- (void)sendMessage:(NSDictionary*)message type:(NSString*)type;
- (void)parseMessage:(NSDictionary*)message;
- (void)handleMessageString:(NSString*)message;

- (NSDictionary*)dictionaryFromMove:(EEMove*)move;
- (EEMove*)moveFromDictionary:(NSDictionary*)dictionary;

@end

@implementation EEOnlineGameController

#pragma mark - Public methods
- (instancetype)initWithConnection:(id <EEGameConnection>)gameConnection {
    self = [super initGameController];
    if (self) {
        _gameConnection = gameConnection;
        [_gameConnection setDelegate:self];
        
        EEPlayerType lOpponentPlayerType = EEPlayerTypeFromString(gameConnection.playerType);
        
        _player = [[EEPlayer alloc] initWithName:NSLocalizedString(@"You", nil) type:EEOppositePlayerTo(lOpponentPlayerType)];
        _opponentPlayer = [[EEPlayer alloc] initWithName:_gameConnection.playerName type:lOpponentPlayerType];
        
        [super resetGame];
        
        _boardSize = EEBoardSizeMake(19, 19);
        _board = [[EEBoard alloc] initWithBoardSize:_boardSize positionWeights:nil];
    }
    return self;
}

- (void)resetGame {
    // this method should be empty, as we cannot make reset for online game
}

- (void)stopGame {
    [self sendToOpponentMessageOfLeavingGame];
}

- (EEMoveStatus)makeMove:(EEMove *)move {
    EEMoveStatus lMoveStatus = [super makeMove:move];
    
    if ((lMoveStatus == EEMoveStatusSuccess) && (move.player.type == _player.type)) {
        [self sendMessage:[self dictionaryFromMove:move] type:TYPE_MOVE];
    }
    
    return lMoveStatus;
}

#pragma mark - Private methods
- (void)sendToOpponentMessageOfLeavingGame {
    [self sendMessage:@{TYPE_MESSAGE : @"leaving_game"} type:TYPE_MESSAGE];
}

- (void)sendMessage:(NSDictionary*)message type:(NSString*)type {
    if (message == nil || type == nil) {
        return;
    }
    
    [_gameConnection sendMessage:[NSKeyedArchiver archivedDataWithRootObject:@{KEY_DATA : message, KEY_TYPE : type}]];
}

- (NSData*)dataFromMove:(EEMove*)move {
    return [NSKeyedArchiver archivedDataWithRootObject:[self dictionaryFromMove:move]];
}

- (void)parseMessage:(NSDictionary*)message {
    if (message == nil) {
        return;
    }
    
    NSDictionary *lMessageData = message[KEY_DATA];
    NSString *lMessageType = message[KEY_TYPE];
    
    if ([lMessageType isEqualToString:TYPE_MOVE]) {
        EEMove *lMove = [self moveFromDictionary:lMessageData];
        
        if (lMove != nil) {
            [self makeMove:lMove];
        }
    } else if ([lMessageType isEqualToString:TYPE_MESSAGE]) {
        [self handleMessageString:lMessageData[TYPE_MESSAGE]];
    }
}

- (void)handleMessageString:(NSString*)message {
    if ([message isEqualToString:@"leaving_game"]) {
        if ([self isGameActive]) {
            _gameStatus = EEGameStatusInterrupted;
            [self sendToDelegateGameInterrupted:EEInterruptionReasonOpponentLeavedGame];
        }
    }
}

- (NSDictionary*)dictionaryFromMove:(EEMove*)move {
    NSMutableDictionary *lDictionary = [NSMutableDictionary new];
    
    [lDictionary setObject:EEPlayerTypeToString(move.player.type) forKey:PLAYER_TYPE];
    [lDictionary setObject:EEBoardSignToString(move.boardSign) forKey:BOARD_SIGN];
    [lDictionary setObject:@(move.point.x) forKey:BOARD_POINT_X];
    [lDictionary setObject:@(move.point.y) forKey:BOARD_POINT_Y];
    
    return lDictionary;
}

- (EEMove*)moveFromDictionary:(NSDictionary*)dictionary {
    if (dictionary == nil) {
        return nil;
    }
    
    EEPlayerType lPlayerType = EEPlayerTypeFromString(dictionary[PLAYER_TYPE]);
    EEBoardSign lBoardSign = EEBoardSignFromString(dictionary[BOARD_SIGN]);
    EEBoardPoint lPoint = EEBoardPointMake([dictionary[BOARD_POINT_X] integerValue], [dictionary[BOARD_POINT_Y] integerValue]);
    
    if (lPlayerType == EEPlayerTypeNone || lBoardSign == EEBoardSignNone) {
        return nil;
    }
    
    EEPlayer *lPlayer = (lPlayerType == _player.type ) ? _player : _opponentPlayer;

    return [EEMove moveWithForPlayer:lPlayer sign:lBoardSign point:lPoint];
}

#pragma mark - EEGameConnectionDelegate
- (void)EEGameConnectionDelegateConnectionLost {
    if ([self isGameActive]) {
        _gameStatus = EEGameStatusInterrupted;
        [self sendToDelegateGameInterrupted:EEInterruptionReasonConnectionLost];
    }
}

- (void)EEGameConnectionDelegateReceivedMessage:(NSData *)message {
    [self parseMessage:[NSKeyedUnarchiver unarchiveObjectWithData:message]];
}

@end
