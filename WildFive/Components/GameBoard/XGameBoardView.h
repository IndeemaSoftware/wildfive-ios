//
//  XGameBoardView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/12/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGameEnums.h"
#import "XAnimationDoc.h"

@interface XGameBoardView : UIView {
    XBoardSize mBoardSize;
    CGRect mRect;
    XAnimationDoc *mAnimationDocView;
    BOOL isBoardAvailable;
}

- (id) initWithFrame:(CGRect)pFrame withBoardSize:(XBoardSize) pBoardSize;

@end
