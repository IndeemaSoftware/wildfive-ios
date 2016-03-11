//
//  EEMove.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/10/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EEGameCommon.h"

@class EEPlayer;

@interface EEMove : NSObject

@property (nonatomic, readonly) EEPlayer *player;
@property (nonatomic, readonly) EEBoardSign boardSign;
@property (nonatomic, readonly) EEBoardPoint point;

- (instancetype)initWithForPlayer:(EEPlayer*)player sign:(EEBoardSign)boardSign point:(EEBoardPoint)point;
+ (EEMove*)moveWithForPlayer:(EEPlayer*)player sign:(EEBoardSign)boardSign point:(EEBoardPoint)point;

@end
