//
//  EEBoardItem.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@interface EEBoardItem : NSObject

@property (nonatomic, readonly) EEBoardSign boardSign;
@property (nonatomic, readonly) EEPlayerType playerType;

- (NSUInteger)positionValueForPlayer:(EEPlayerType)playerType;

@end
