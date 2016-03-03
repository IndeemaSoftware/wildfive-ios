//
//  XBot.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 10/02/2012.
//  Copyright 2012 XIO Games. All rights reserved.
//

#import "XBot.h"

@implementation XBot
@synthesize boardArray=mBoardArray;
@synthesize valueArray=mValueArray;
@synthesize botLevel=mLevel;
@synthesize botType=mType;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        mBoardArray = nil;
        mValueArray = nil;
        mLevel = XGameLevelEasy;
        mAttackFactor = 1;
        mType = XPlayerTypeCross;
        mOpponent = XPlayerTypeToe;
    }
    
    return self;
}

- (void) setBotLevel:(XGameLevel)pBotLevel {
    if (XGameLevelEasy == pBotLevel) {
        mLevel = XGameLevelEasy;
        mAttackFactor = 1;
    } else if (XGameLevelMedium == pBotLevel) {
        mLevel = XGameLevelMedium;
        mAttackFactor = 2;
    } else if (XGameLevelHard == pBotLevel) {
        mLevel = XGameLevelHard;
        mAttackFactor = 4;
    }
}

- (void) setBotType:(XPlayerType)pBotType {
    if (XPlayerTypeCross == pBotType) {
        mType = XPlayerTypeCross;
        mOpponent = XPlayerTypeToe;
    } else {
        mType = XPlayerTypeToe;
        mOpponent = XPlayerTypeCross;
    }
}

- (XBoardPoint) findBestPosition {
    XBoardPoint lResult = XBoardPointMake(1, 1);

    if (mBoardArray && mValueArray) {        
        NSInteger lMaxValue = 0;
        NSUInteger lBoardWidth = [mBoardArray count];
        NSUInteger lBoardHeight = [[mBoardArray objectAtIndex:0] count];
        CGFloat lAttackValue = (16 + mAttackFactor) / 16;
        BOOL lIsAllEmpty = YES;
        
        //init first value
        lMaxValue = (NSInteger)floorf([[[[mValueArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:mType] integerValue] * lAttackValue) + [[[[mValueArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:mOpponent] integerValue];
        for (NSUInteger positionX = 0; positionX < lBoardWidth; positionX++) {
            for (NSUInteger positionY = 0; positionY < lBoardHeight; positionY++) {
                XPlayerType lBoardValue = [[[mBoardArray objectAtIndex:positionX] objectAtIndex:positionY] integerValue];
                if (XPlayerTypeEmpty == lBoardValue) {
                    NSInteger lValue = (NSInteger)floorf([[[[mValueArray objectAtIndex:positionX] objectAtIndex:positionY] objectAtIndex:mType] integerValue] * lAttackValue) + [[[[mValueArray objectAtIndex:positionX] objectAtIndex:positionY] objectAtIndex:mOpponent] integerValue];
                    if (lValue >= lMaxValue) {
                        lMaxValue = lValue;
                        lResult =  XBoardPointMake(positionX, positionY);
                    }
                } else {
                    if (lIsAllEmpty) {
                        lIsAllEmpty = NO;
                    }
                }
            }
        }
        NSLog(@"lMaxValue %i", lMaxValue);
        if (lIsAllEmpty) {
            lResult = XBoardPointMake((int)floorf(lBoardWidth / 2), (int)floorf(lBoardHeight / 2));
        }
    }

    return lResult;
}

- (void) dealloc {
    [super dealloc];
}

@end
