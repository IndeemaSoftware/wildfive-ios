//
//  XGameEnums.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 11/02/2012.
//  Copyright 2012 XIO Games. All rights reserved.
//

#ifndef WildFive_XGameEnums_h
#define WildFive_XGameEnums_h

#define DEFAULT_BOARD_SIZE 19

typedef enum {
    XGameLevelEasy,
    XGameLevelMedium,
    XGameLevelHard,
    XGameLevelPlayer
} XGameLevel;

typedef enum {
    XPlayerTypeToe,
    XPlayerTypeCross,
    XPlayerTypeEmpty
} XPlayerType;

typedef enum {
    XLineDirectionH,
    XLineDirectionHVR,
    XLineDirectionV,
    XLineDirectionHVL
} XLineDirection;

typedef struct  {
    NSUInteger width;
    NSUInteger height;
} XBoardSize;

typedef struct  {
    NSUInteger x;
    NSUInteger y;
} XBoardPoint;

XBoardSize XBoardSizeMake(NSUInteger pWidth, NSUInteger pHeight);
XBoardPoint XBoardPointMake(NSInteger pX, NSInteger pY);
#endif
