//
//  EELocalConnectionAdvertiser.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class EEEsteblishedConnection;

@protocol EELocalConnectionManagerDelegate;

@interface EELocalConnectionManager : NSObject

@property (nonatomic, copy) NSString *advertisingName;

@property (nonatomic, readonly) BOOL isAdvertising;
@property (nonatomic, readonly) BOOL isBrowsing;

@property (nonatomic, readonly) NSArray *browsedPeers;

@property (nonatomic, weak) id <EELocalConnectionManagerDelegate> delegate;

- (instancetype)initWithAdvertisingName:(NSString*)advertisingName;

- (void)startAdvertiser;
- (void)stopAdvertiser;

- (void)startBrowsing;
- (void)stopBrowsing;

- (void)sendInvitationToPeer:(MCPeerID*)peerId;

@end

@protocol EELocalConnectionManagerDelegate <NSObject>
- (void)EELocalConnectionBrowserUpdatePeers;
- (void)EELocalConnectionEsteblishedConnection:(EEEsteblishedConnection*)connection;
@end
