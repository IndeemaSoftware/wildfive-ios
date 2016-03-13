//
//  EEGameConnection.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/13/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameConnection.h"
#import "EEEsteblishedConnection.h"

@interface EEGameConnection() <MCSessionDelegate> {
    MCSession *_session;
}

@end

@implementation EEGameConnection

#pragma mark - Public methods
- (instancetype)initWithConnection:(EEEsteblishedConnection *)connection {
    NSAssert(connection != nil, @"EELocalGameConnection - connection cannot be nil.");
    self = [super init];
    if (self) {
        _playerName = connection.playerName;
        _playerType = connection.playerType;
        
        _session = connection.session;
        [_session setDelegate:self];
    }
    return self;
}

+ (instancetype)gameConnectionWith:(EEEsteblishedConnection *)connection {
    return [[EEGameConnection alloc] initWithConnection:connection];
}

- (void)sendMessage:(NSData *)message {
    if (_session != nil) {
        NSError *lError = nil;
        [_session sendData:message toPeers:_session.connectedPeers withMode:MCSessionSendDataReliable error:&lError];
        
        if (lError != nil) {
            DLog(@"sending error %@", lError.localizedDescription);
        }
    }
}

#pragma mark - Private methods

#pragma mark - MCSession delegate's methods
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    DLog(@"didFinishReceivingResourceWithName resourceName %@", resourceName);
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler {
    DLog(@"didReceiveCertificate %@", certificate);
    certificateHandler(YES);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    [self.delegate EEGameConnectionDelegateReceivedMessage:data];
//    DLog(@"didReceiveData %@", data);
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    DLog(@"didReceiveStream %@", stream);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    DLog(@"didStartReceivingResourceWithName %@", resourceName);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        DLog(@"MCSessionState Connected %@", session);
    } else if (state == MCSessionStateConnecting) {
        DLog(@"MCSessionState Connecting %@", session);
    } else {
        DLog(@"MCSessionState Not Connected");
        [self.delegate EEGameConnectionDelegateConnectionLost];
    }
}

@end
