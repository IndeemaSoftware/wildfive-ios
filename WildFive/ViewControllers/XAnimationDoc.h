//
//  XAnimationDoc.h
//  WildFive
//
//  Created by Lion User on 30/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGameBoard.h"
#import "XAppDelegate.h"
#import "XGameBoardCell.h"
#import "XMessageView.h"
//#import "XGameBoardView.h"
#import "XDemonstrationPlayingView.h"

#define IS_FIRST @"isFirst"

@protocol XAnimationDocDelegate<NSObject>
@optional
- (void)animationDidStart;
- (void)animationDidEnd;
@end
@interface XAnimationDoc : UIView{
    XDemonstrationPlayingView *mAnimationDocBoard;
    UIImageView *mHandImg;
    UIImageView *mCross;
    UIImageView *mToe;
    UIImageView *mCrossSettedOnPosition;
    UIImageView *mRealFingerImg;
    UIButton *mHint;
    CGRect mPlayingFieldDocRect;
    id <XAnimationDocDelegate> delegate;
}
@property (nonatomic, assign)id <XAnimationDocDelegate> delegate;
@property (nonatomic, assign)id <XAnimationDocDelegate> delegateToGameViewController;
-(void) stopAnimation;
- (void)makeAnimation:(NSDictionary*)pDictPoints;
@end

@interface XPoint : NSObject
@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;
- (XPoint*)initWithPoint:(CGPoint)pPoint;
@end
