//
//  XGameBoardDelegate.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/14/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGameEnums.h"

@protocol XGameBoardDelegate <NSObject>
- (void) boardViewPushAt:(XBoardPoint) pPosition;
@required
- (XPlayerType)gameboardCurrentPlayer;
@end
