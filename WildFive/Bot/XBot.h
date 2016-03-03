//
//  XBot.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 10/02/2012.
//  Copyright 2012 XIO Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XGameEnums.h"

@interface XBot : NSObject {
    NSArray *mBoardArray;
    NSArray *mValueArray;
    
    XGameLevel mLevel;
    
    XPlayerType mType;
    XPlayerType mOpponent;
    
    NSInteger mAttackFactor;
}
@property (nonatomic, assign) NSArray *boardArray;
@property (nonatomic, assign) NSArray *valueArray;
@property (nonatomic) XGameLevel botLevel;
@property (nonatomic) XPlayerType botType;

//this method returns point
- (XBoardPoint) findBestPosition;
@end
