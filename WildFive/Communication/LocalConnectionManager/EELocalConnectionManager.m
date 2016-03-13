//
//  EELocalConnectionAdvertiser.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EELocalConnectionManager.h"
#import "EEEsteblishedConnection.h"

static NSString * const sServiceName = @"wildfive-game";

@interface EELocalConnectionManager() <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate> {
    MCPeerID *_peerId;
    
    MCNearbyServiceAdvertiser *_nearbyServiceAdvertiser;
    MCNearbyServiceBrowser *_nearbyServiceBrowser;
    
    MCSession *_receivedSession;
    MCSession *_sentSession;
    
    NSMutableArray *_browsedPeersArray;
    NSMutableArray *_connectingPeersArray;
}

- (MCPeerID*)peerId;

- (MCNearbyServiceAdvertiser*)nearbyServiceAdvertiser;
- (MCNearbyServiceBrowser*)nearbyServiceBrowser;

- (NSMutableArray*)browsedPeersArray;
- (NSMutableArray*)connectingPeersArray;

- (void)notifyDelegateAboutChangesInFoundItems;
- (BOOL)askDelegateToShowAlert:(UIAlertController*)alertController;

@end

@implementation EELocalConnectionManager

#pragma mark - Public methods
- (instancetype)initWithAdvertisingName:(NSString*)advertisingName {
    self = [super init];
    if (self) {
        if (advertisingName.length == 0) {
            _advertisingName = [[UIDevice currentDevice] name];
        } else {
            _advertisingName = advertisingName;
        }
        
    }
    return self;
}

- (instancetype)init {
    return [self initWithAdvertisingName:[[UIDevice currentDevice] name]];
}

- (void)setAdvertisingName:(NSString *)advertisingName {
    if ([_advertisingName isEqualToString:advertisingName]) {
        return;
    }
    
    _advertisingName = [advertisingName copy];
    
    _peerId = nil;
    
    if (_isAdvertising) {
        [self.nearbyServiceAdvertiser stopAdvertisingPeer];
        _nearbyServiceAdvertiser = nil;
        [self.nearbyServiceAdvertiser startAdvertisingPeer];
    }
    
    if (_isBrowsing) {
        [self.nearbyServiceBrowser stopBrowsingForPeers];
        _nearbyServiceAdvertiser = nil;
        [self.nearbyServiceBrowser startBrowsingForPeers];
    }
}

- (NSArray *)browsedPeers {
    return self.browsedPeersArray;
}

- (void)startAdvertiser {
    _isAdvertising = YES;
    [self.nearbyServiceAdvertiser startAdvertisingPeer];
}

- (void)stopAdvertiser {
    _isAdvertising = NO;
    [self.nearbyServiceAdvertiser stopAdvertisingPeer];
}

- (void)startBrowsing {
    _isBrowsing = YES;
    [self.nearbyServiceBrowser startBrowsingForPeers];
}

- (void)stopBrowsing {
    _isBrowsing = NO;
    [self.nearbyServiceBrowser stopBrowsingForPeers];
}

- (void)sendInvitationToPeer:(MCPeerID*)peerId {
    if (_receivedSession != nil || _sentSession != nil) {
        return;
    }
    
    _sentSession = [[MCSession alloc] initWithPeer:self.peerId securityIdentity:nil encryptionPreference:MCEncryptionRequired];
    [_sentSession setDelegate:self];
    
    [self.nearbyServiceBrowser invitePeer:peerId toSession:_sentSession withContext:nil timeout:10];
}

- (void)dealloc {
    [self stopBrowsing];
    [self stopAdvertiser];
    
    _receivedSession = nil;;
    _sentSession = nil;
    
    [self.browsedPeersArray removeAllObjects];
    [self.connectingPeersArray removeAllObjects];
}

#pragma mark - Private methods
- (MCPeerID*)peerId {
    if (_peerId == nil) {
        _peerId = [[MCPeerID alloc] initWithDisplayName:self.advertisingName];
    }
    return _peerId;
}

- (MCNearbyServiceAdvertiser*)nearbyServiceAdvertiser {
    if (_nearbyServiceAdvertiser == nil) {
        _nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerId discoveryInfo:nil serviceType:sServiceName];
        [_nearbyServiceAdvertiser setDelegate:self];
    }
    return _nearbyServiceAdvertiser;
}

- (MCNearbyServiceBrowser*)nearbyServiceBrowser {
    if (_nearbyServiceBrowser == nil) {
        _nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerId serviceType:sServiceName];
        [_nearbyServiceBrowser setDelegate:self];
    }
    return _nearbyServiceBrowser;
}

- (NSMutableArray*)browsedPeersArray {
    if (_browsedPeersArray == nil) {
        _browsedPeersArray = [NSMutableArray new];
    }
    return _browsedPeersArray;
}

- (NSMutableArray*)connectingPeersArray {
    if (_connectingPeersArray == nil) {
        _connectingPeersArray = [NSMutableArray new];
    }
    return _connectingPeersArray;
}

- (void)notifyDelegateAboutChangesInFoundItems {
    if (self.delegate != nil) {
        [self.delegate EELocalConnectionBrowserUpdatePeers];
    } else {
        DLog(@"EELocalConnection delegate not found.");
    }
}

- (BOOL)askDelegateToShowAlert:(UIAlertController*)alertController {
    if (self.delegate != nil) {
        [self.delegate EELocalConnectionNeedPressentAlert:alertController];
        return YES;
    } else {
        DLog(@"EELocalConnection delegate not found.");
    }
    
    return NO;
}

#pragma mark - MCNearbyServiceAdvertiser delegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler {
    __block MCSession *lSession;
    
    if (_sentSession != nil || _receivedSession != nil || !_isAdvertising) {
        invitationHandler(NO, lSession);
        return;
    }
    
    _receivedSession = [[MCSession alloc] initWithPeer:self.peerId securityIdentity:nil encryptionPreference:MCEncryptionRequired];
    [_receivedSession setDelegate:self];
    
    lSession = _receivedSession;
    
    if ([self.connectingPeersArray containsObject:peerID]) {
        invitationHandler(NO, lSession);
        return;
    }
    
    [self.connectingPeersArray addObject:peerID];
    
    
    UIAlertController *lInvitationAlertController = [[UIAlertController alloc] init];
    
    [lInvitationAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Accept", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        invitationHandler(YES, lSession);
        [self.connectingPeersArray removeObject:peerID];
    }]];
    
    // decline invitation action
    [lInvitationAlertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Decline", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        invitationHandler(NO, lSession);
        [self.connectingPeersArray removeObject:peerID];
        _receivedSession = nil;
    }]];
    
    
    if (![self askDelegateToShowAlert:lInvitationAlertController]) {
        invitationHandler(NO, lSession);
        [self.connectingPeersArray removeObject:peerID];
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    DLog(@"Error starting advertiser: %@", error.localizedDescription);
}

#pragma mark - MCNearbyServiceBrowser delegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    DLog(@"withDiscoveryInfo %@", peerID);
    
    if (![self.browsedPeersArray containsObject:peerID]) {
        [self.browsedPeersArray addObject:peerID];
        [self notifyDelegateAboutChangesInFoundItems];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    if ([self.browsedPeersArray containsObject:peerID]) {
        [self.browsedPeersArray removeObject:peerID];
        [self notifyDelegateAboutChangesInFoundItems];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    DLog(@"Error starting browsing: %@", error.localizedDescription);
}

#pragma mark - MCSesion delegate
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    DLog(@"didFinishReceivingResourceWithName resourceName %@", resourceName);
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler {
    DLog(@"didReceiveCertificate %@", certificate);
    certificateHandler(YES);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    DLog(@"didReceiveData %@", data);
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
        
        [session setDelegate:nil];
        
        EEEsteblishedConnection *lEsteblishedConnection = [EEEsteblishedConnection new];
        lEsteblishedConnection.session = session;
        
        if (session.connectedPeers.count != 0) {
            lEsteblishedConnection.playerName = session.connectedPeers[0].displayName;
        } else {
            lEsteblishedConnection.playerName = NSLocalizedString(@"Opponent", nil);
        }
        
        
        if ([_sentSession isEqual:session]) {
            _sentSession = nil;
            lEsteblishedConnection.playerType = @"O";
        } else {
            _receivedSession = nil;
            lEsteblishedConnection.playerType = @"X";
        }
        
        [self.delegate EELocalConnectionEsteblishedConnection:lEsteblishedConnection];
    } else if (state == MCSessionStateConnecting) {
        DLog(@"MCSessionState Connecting %@", session);
    } else {
        _sentSession = nil;
        _receivedSession = nil;
        
        DLog(@"MCSessionState Not Connected");
    }
}

@end
