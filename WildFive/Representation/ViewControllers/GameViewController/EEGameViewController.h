//
//  EEGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFlowViewController.h"

@class EEGameController;

@interface EEGameViewController : EEFlowViewController

@property (nonatomic, readonly) EEGameController *gameController;

- (instancetype)initWithGame:(EEGameController*)gameController;

@end
