//
//  EEPlayerView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEGameCommon.h"

@interface EEPlayerView : UIView

@property (nonatomic, assign) EEPlayerType playerType;
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, assign, getter=isActive) BOOL active;

@end
