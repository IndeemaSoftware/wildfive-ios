//
//  EEBoard.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@class EEBoardItem;

@interface EEBoard : NSObject

@property (nonatomic, readonly) EEBoardSize boardSize;

- (instancetype)initWithBoardSize:(EEBoardSize)boardSize;
- (EEBoardItem*)itemAtPoint:(EEBoardPoint)boardPoint;
- (EEBoardItem*)firstItem;
- (EEBoardItem*)lastItem;

@end
