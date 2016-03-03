//
//  XBluetoothGamesTableDelegate.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 21/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XBluetoothGamesTableDelegate <NSObject>
- (void) bluetoothGamesTableCreatePressed:(id)pCreateButton;
- (void) bluetoothGamesTableConnectPressed:(id)pConnectButton withPeerID:(NSString*)pPeerID;
@end
