//
//  XViewSizeSettingsAboveBoard.h
//  WildFive
//
//  Created by naceka on 21.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface XSettingsViewSizeAboveBoard : UIView {
    CGRect      mRectResize;
    UILabel     *mLabelCircle;
    UILabel     *mLabelDisplaySize;
    //UIImageView *mImageCircle;

    CABasicAnimation *mAnimationForArrow;
    UIImageView *mImageViewArrow;
    BOOL isCanMoved;
}
@property(nonatomic, copy) void (^displaySize)(NSString *);
- (void) initData;


@end
