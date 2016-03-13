//
//  EEGCGameConnection.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/13/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGCGameConnection.h"
#import <GameKit/GameKit.h>

#import "EEEsteblishedConnection.h"
#import "EEGameConnectionDelegate.h"

@interface EEGCGameConnection() <GKMatchDelegate> {
    GKMatch *_match;
}

@end

@implementation EEGCGameConnection

@synthesize playerType=_playerType;
@synthesize playerName=_playerName;
@synthesize connectionType=_connectionType;
@synthesize delegate=_delegate;

#pragma mark - Public methods
- (instancetype)initWithConnection:(EEEsteblishedConnection *)connection {
    NSAssert(connection != nil, @"EELocalGameConnection - connection cannot be nil.");
    self = [super init];
    if (self) {
        _playerName = connection.playerName;
        _playerType = connection.playerType;
        
        _match = connection.connectionObject;
        [_match setDelegate:self];
    }
    return self;
}

+ (instancetype)gameConnectionWith:(EEEsteblishedConnection *)connection {
    return [[EEGCGameConnection alloc] initWithConnection:connection];
}

- (void)sendMessage:(NSData *)message {
    if (_match != nil) {
        NSError *lError = nil;
        [_match sendData:message toPlayers:_match.players dataMode:GKMatchSendDataReliable error:&lError];
        
        if (lError != nil) {
            DLog(@"EEGCGameConnection sending error %@", lError.localizedDescription);
        }
    }
}

- (void)dealloc {
    [_match disconnect];
}

#pragma mark - Private methods

#pragma mark - GKMatchDelegate
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player {
    [self.delegate EEGameConnectionDelegateReceivedMessage:data];
    DLog(@"didReceiveData fromRemotePlayer %@", player);
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data forRecipient:(GKPlayer *)recipient fromRemotePlayer:(GKPlayer *)player {
    DLog(@"didReceiveData forRecipient %@ fromRemotePlayer %@", recipient, player);
}

- (void)match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state {
    if (state == GKPlayerStateConnected) {
        DLog(@"GKPlayerConnectionState Connected");
    } else if (state == GKPlayerStateDisconnected) {
        DLog(@"GKPlayerConnectionState Disconnected");
        [self.delegate EEGameConnectionDelegateConnectionLost];
    } else {
         DLog(@"GKPlayerConnectionState Unknown");
    }
}

- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    DLog(@"EEGCGameConnection didFailWithError %@", error);
}

- (BOOL)match:(GKMatch *)match shouldReinviteDisconnectedPlayer:(GKPlayer *)player {
    return NO;
}



//
//- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
//    [self.delegate EEGameConnectionDelegateReceivedMessage:data];
//    //    DLog(@"didReceiveData %@", data);
//}
//
//- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
//    DLog(@"didReceiveStream %@", stream);
//}
//
//- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
//    DLog(@"didStartReceivingResourceWithName %@", resourceName);
//}
//
//- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
//    if (state == MCSessionStateConnected) {
//        DLog(@"MCSessionState Connected %@", session);
//    } else if (state == MCSessionStateConnecting) {
//        DLog(@"MCSessionState Connecting %@", session);
//    } else {
//        DLog(@"MCSessionState Not Connected");
//        [self.delegate EEGameConnectionDelegateConnectionLost];
//    }
//}

@end
