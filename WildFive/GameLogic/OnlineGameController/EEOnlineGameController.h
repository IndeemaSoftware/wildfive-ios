//
//  EEOnlineGameController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameController.h"

@protocol EEGameConnection;

@interface EEOnlineGameController : EEGameController

- (instancetype)initWithConnection:(id <EEGameConnection>)gameConnection;

@end
