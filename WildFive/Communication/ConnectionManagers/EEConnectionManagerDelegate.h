//
//  EEConnectionManagerDelegate.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 25/05/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EEEsteblishedConnection;

@protocol EEConnectionManagerDelegate <NSObject>

- (void)EEConnectionManagerBrowserUpdatePeers;
- (void)EEConnectionManagerEstablishedConnection:(EEEsteblishedConnection*)connection;

@end
