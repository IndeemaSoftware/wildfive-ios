//
//  EEGCConnectionManager.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/15/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGCConnectionManager.h"
#import "EEEsteblishedConnection.h"

#define PLAYER_CROSS 0xFFFF0000
#define PLAYER_CIRCLE 0x0000FFFF

@interface EEGCConnectionManager() {
    NSMutableSet *_availablePlayers;
}

- (NSMutableSet*)availablePlayers;

- (void)notifyDelegateAboutChangesInFoundItems;

@end

@implementation EEGCConnectionManager

#pragma mark - Public methods

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)browsedPlayers {
    return _availablePlayers.allObjects;
}

- (void)invitePllayer:(GKPlayer*)player {
    [self stopBrowsing];
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        NSLog(@"Local player is not authenticated");
        return;
    }
    
    GKMatchRequest *lMatchRequest = [[GKMatchRequest alloc] init];
//    lMatchRequest.playerAttributes = PLAYER_CIRCLE;
    [lMatchRequest setPlayerGroup:1];
    lMatchRequest.minPlayers = 2;
    lMatchRequest.maxPlayers = 2;
    lMatchRequest.recipients = @[player];
    
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:lMatchRequest withCompletionHandler:^(GKMatch * _Nullable match, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"match players %@", match.players);
            
            EEEsteblishedConnection *lEsteblishedConnection = [EEEsteblishedConnection new];
            lEsteblishedConnection.connectionObject = match;
            lEsteblishedConnection.connectionType = EEGameConnectionTypeGameCenter;
            lEsteblishedConnection.playerType = @"X";
            
            if (match.players.count != 0) {
                lEsteblishedConnection.playerName = match.players[0].alias;
            } else {
                lEsteblishedConnection.playerName = NSLocalizedString(@"Opponent", nil);
            }
            
            [self.delegate EEConnectionManagerEstablishedConnection:lEsteblishedConnection];
        } else {
            NSLog(@"findMatchForRequest error %@", error);
        }
    }];
}

- (void)startAdvertiser {
    [self stopBrowsing];
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        NSLog(@"Local player is not authenticated");
        return;
    }
    
    GKMatchRequest *lMatchRequest = [[GKMatchRequest alloc] init];
    lMatchRequest.playerAttributes = PLAYER_CROSS;
    [lMatchRequest setPlayerGroup:1];
    lMatchRequest.minPlayers = 2;
    lMatchRequest.maxPlayers = 2;
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:lMatchRequest withCompletionHandler:^(GKMatch * _Nullable match, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"match players %@", match.players);
            
            EEEsteblishedConnection *lEsteblishedConnection = [EEEsteblishedConnection new];
            lEsteblishedConnection.connectionObject = match;
            lEsteblishedConnection.connectionType = EEGameConnectionTypeGameCenter;
            lEsteblishedConnection.playerType = @"X";
            
            if (match.players.count != 0) {
                lEsteblishedConnection.playerName = match.players[0].alias;
            } else {
                lEsteblishedConnection.playerName = NSLocalizedString(@"Opponent", nil);
            }
            
            [self.delegate EEConnectionManagerEstablishedConnection:lEsteblishedConnection];
        } else {
            NSLog(@"findMatchForRequest error %@", error);
        }
    }];
}

- (void)stopAdvertiser {
    
}

- (void)startBrowsing {
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        NSLog(@"Local player is not authenticated");
        return;
    }
    
    GKMatchRequest *lMatchRequest = [[GKMatchRequest alloc] init];
    lMatchRequest.playerAttributes = PLAYER_CIRCLE;
    [lMatchRequest setPlayerGroup:1];
    lMatchRequest.minPlayers = 2;
    lMatchRequest.maxPlayers = 2;
    
    [[GKMatchmaker sharedMatchmaker] findPlayersForHostedRequest:lMatchRequest withCompletionHandler:^(NSArray<GKPlayer *> * _Nullable players, NSError * _Nullable error) {
        if (error == nil && players != nil) {
            [self.availablePlayers addObjectsFromArray:players];
            [self notifyDelegateAboutChangesInFoundItems];
        } else {
            NSLog(@"findPlayersForHostedRequest error %@", error);
        }
    }];
}

- (void)stopBrowsing {
    [[GKMatchmaker sharedMatchmaker] cancel];
}

- (void)dealloc {
    [self stopBrowsing];
    [self stopAdvertiser];
    
    [_availablePlayers removeAllObjects];
    _availablePlayers = nil;
}

#pragma mark - Private methods
- (NSMutableSet*)availablePlayers {
    if (_availablePlayers == nil) {
        _availablePlayers = [NSMutableSet new];
    }
    return _availablePlayers;
}

- (void)notifyDelegateAboutChangesInFoundItems {
    if (self.delegate != nil) {
        [self.delegate EEConnectionManagerBrowserUpdatePeers];
    } else {
        DLog(@"EEGCConnectionManager delegate not found.");
    }
}

@end
