//
//  XGameBoard.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGameEnums.h"

@class XGameBoardView;
@class XGameBoardCell;

@interface XGameBoard : UIScrollView { 
    UIImageView *mHandView;
    
    XBoardSize mBoardSize;
    CGPoint mSymbolPosition;
    
    XGameBoardView *mGameBoardView;
    XGameBoardCell *mCurrentCell;
    
    NSTimer *mLockSymbolTimer;
    BOOL mIsSymbolLocked;
    BOOL mIsShowingHint;
    id mDelegate;
}

@property (nonatomic) XPlayerType currentPlayer;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) BOOL isShowingHint;

- (id) initWithFrame:(CGRect) pFrame boardDimention:(XBoardSize) pBoardSize;

- (void)putSymbolAtPosition:(XBoardPoint) pPoint;
- (void)highlightSymbolAtPosition:(XBoardPoint) pPoint;
- (void)showHintAtPosition:(XBoardPoint) pPoint;
- (BOOL)clearBoard;
@end
