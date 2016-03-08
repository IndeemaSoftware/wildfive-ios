//
//  EEGameCommon.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#ifndef EEGameCommon_h
#define EEGameCommon_h

typedef NS_ENUM(NSInteger, EEBotLevel) {
    EEBotEasy,
    EEBotMedium,
    EEBotHard
};

typedef NS_ENUM(NSInteger, EEPlayerType) {
    EEPlayerTypeError = -1,
    EEPlayerTypeNone,
    EEPlayerTypeO,
    EEPlayerTypeX
};

typedef NS_ENUM(NSInteger, EEBoardSign) {
    EEBoardSignError = -1,
    EEBoardSignNone,
    EEBoardSignO,
    EEBoardSignX
};

typedef NS_ENUM(NSInteger, EELineDirection) {
    EELineDirectionH,
    EELineDirectionHVR,
    EELineDirectionV,
    EELineDirectionHVL
};

typedef struct  {
    NSUInteger width;
    NSUInteger height;
} EEBoardSize;

typedef struct  {
    NSUInteger x;
    NSUInteger y;
} EEBoardPoint;


CG_INLINE EEPlayerType EEOppositePlayerTo(EEPlayerType player) {
    if (player == EEBoardSignX) {
        return EEPlayerTypeO;
    } else if (player == EEBoardSignO) {
        return EEPlayerTypeX;
    }
    
    return EEPlayerTypeNone;
}

/// ------------- IN LINE FUNCTIONS

CG_INLINE EEBoardSize EEBoardSizeMake(NSUInteger width, NSUInteger height);
CG_INLINE EEBoardPoint EEBoardPointMake(NSInteger x, NSInteger y);

/// ------------- IN LINE FUNCTIONS REALIZATION

CG_INLINE EEBoardSize EEBoardSizeMake(NSUInteger width, NSUInteger height) {
    EEBoardSize lBoardSize;
    lBoardSize.width = width;
    lBoardSize.height = height;
    return lBoardSize;
}

CG_INLINE EEBoardPoint EEBoardPointMake(NSInteger x, NSInteger y) {
    EEBoardPoint lBoardPoint;
    lBoardPoint.x = x;
    lBoardPoint.y = y;
    
    return lBoardPoint;
}

#endif /* EEGameCommon_h */
