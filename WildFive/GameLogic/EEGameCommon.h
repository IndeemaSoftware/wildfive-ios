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
    EELineDirectionH = 0,
    EELineDirectionHVR,
    EELineDirectionV,
    EELineDirectionHVL
};

typedef NS_ENUM(NSInteger, EEMoveStatus) {
    EEMoveStatusSuccess,
    EEMoveStatusIsPointOutsideTheBoard,
    EEMoveStatusIsPointBusy,
    EEMoveStatusGameFinished
};

typedef NS_ENUM(NSInteger, EEGameStatus) {
    EEGameStatusActive,
    EEGameStatusFinish,
};

typedef struct  {
    NSUInteger width;
    NSUInteger height;
} EEBoardSize;

typedef struct  {
    NSInteger x;
    NSInteger y;
} EEBoardPoint;

typedef struct  {
    EEBoardPoint origin;
    EEBoardSize size;
} EEBoardFrame;

typedef struct  {
    BOOL hasWinner;
    EEPlayerType playerType;
    EEBoardPoint startPoint;
    EELineDirection lineDirection;
    NSUInteger lineLenght;
} EEFinishResult;

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
CG_INLINE EEBoardFrame EEBoardFrameMake(NSInteger x, NSInteger y, NSUInteger width, NSUInteger height);

CG_INLINE BOOL EEBoardPointIsInsideBoard(EEBoardPoint point, EEBoardSize boardSize);
CG_INLINE BOOL EEBoardPointIsInsideBoardFrame(EEBoardPoint point, EEBoardFrame boardFrame);

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

CG_INLINE EEBoardFrame EEBoardFrameMake(NSInteger x, NSInteger y, NSUInteger width, NSUInteger height) {
    EEBoardFrame lBoardFrame;
    lBoardFrame.origin.x = x;
    lBoardFrame.origin.y = y;
    lBoardFrame.size.width = width;
    lBoardFrame.size.height = height;
    
    return lBoardFrame;
}

CG_INLINE BOOL EEBoardPointIsInsideBoard(EEBoardPoint point, EEBoardSize boardSize) {
    return (point.x >= 0) && (point.x < boardSize.width) && (point.y >= 0) && (point.y < boardSize.height);
}

CG_INLINE BOOL EEBoardPointIsInsideBoardFrame(EEBoardPoint point, EEBoardFrame boardFrame) {
    return (point.x >= boardFrame.origin.x) && (point.x < boardFrame.size.width) && (point.y >= boardFrame.origin.y) && (point.y < boardFrame.size.height);
}

#endif /* EEGameCommon_h */
