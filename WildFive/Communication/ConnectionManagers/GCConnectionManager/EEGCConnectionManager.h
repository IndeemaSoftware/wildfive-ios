//
//  EEGCConnectionManager.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/15/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "EEConnectionManagerDelegate.h"

@interface EEGCConnectionManager : NSObject

@property (nonatomic, readonly) NSArray <GKPlayer*> *browsedPlayers;
@property (nonatomic, weak) id <EEConnectionManagerDelegate> delegate;

- (void)invitePllayer:(GKPlayer*)player;

- (void)startAdvertiser;
- (void)stopAdvertiser;

- (void)startBrowsing;
- (void)stopBrowsing;

@end