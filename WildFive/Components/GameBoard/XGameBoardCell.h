//
//  XGameBoardCell.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGameEnums.h"

@interface XGameBoardCell : UIImageView {
    UIImageView *mImageView;
    
    BOOL mEnabled;
    
    XBoardPoint mSymbolPosition;
    
    XPlayerType mState;
}

@property (nonatomic, assign) XPlayerType currentUser;
@property (nonatomic, assign) XBoardPoint symbolPosition;

+ (CGSize) cellSize;

@end
