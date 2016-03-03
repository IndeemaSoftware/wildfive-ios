//
//  XAnimationDoc.m
//  WildFive
//
//  Created by Lion User on 30/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XAnimationDoc.h"

#define HAND_WIDTH_IPAD 128.0f
#define HAND_HEIGHT_IPAD 221.0f
#define HAND_WIDTH_IPHONE 80.0f
#define HAND_HEIGHT_IPHONE 140.0f

#define HAND_X_OFFSET_IPAD 50.0f
#define HAND_X_OFFSET_IPHONE 30.0f


@implementation XAnimationDoc

@synthesize delegate;

#pragma mark - inits
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        

        
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.7];
        [self setUserInteractionEnabled:NO];
        
        CGRect lAnimationDocViewRect;
        
        if ([deviceType() isEqualToString:IPHONE]) {
            lAnimationDocViewRect = CGRectMake(44, 20, 213, 213);
        } else if ([deviceType() isEqualToString:IPAD]){
            lAnimationDocViewRect = CGRectMake(127.5f,100.0f, 513.0f, 513.0f);
        }

        mAnimationDocBoard =[[XDemonstrationPlayingView alloc] initWithFrame:lAnimationDocViewRect];
        mCross = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"board_cross@2x"]];
        mToe = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"board_toe@2x"]];
        mRealFingerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finger.png"] highlightedImage:[UIImage imageNamed:@"fingerActive.png"]];
        mCrossSettedOnPosition = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"board_cross@2x"]];
        mHint = [UIButton new];
        [mHint setBackgroundImage:[UIImage imageNamed:@"bubble.png"] forState:UIControlStateNormal];
        [mHint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mHint setAlpha:1.0];
        CGFloat lHintTextSize;
        CGRect lHintRect;
        CGRect lHideButtonRect;
        CGFloat lEdgeInset;
        if ([deviceType() isEqualToString:IPHONE]) {
            lHintTextSize = 13.0f;
            lHintRect = CGRectMake(150.0f, 20.0f, 140.0f, 60.0f);
            lHideButtonRect = CGRectMake(100, 500, 100, 50);
            lEdgeInset = 15.0;
        } else if ([deviceType() isEqualToString:IPAD]){
            lHintTextSize = 28.0f;
            lHintRect = CGRectMake(400, 100, 250, 130);
            lHideButtonRect = CGRectMake(100, 700, 150, 80);
            lEdgeInset = 15.0;
        }
        [mHint.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:lHintTextSize]];
        [mHint setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 15, 0)];
        [mHint.titleLabel setNumberOfLines:2];
        [mHint setFrame:lHintRect];

    }
    return self;
}



- (void)drawRect:(CGRect)rect{
    [mAnimationDocBoard addSubview:mHandImg];
    [self addSubview:mAnimationDocBoard];
    XPoint *lStartPoint = [[XPoint alloc] initWithPoint:CGPointMake(5, 9)];
    XPoint *lFinishPoint = [[XPoint alloc] initWithPoint:CGPointMake(5, 5)];
    XPoint *lToePoint = [[XPoint alloc] initWithPoint:CGPointMake(2, 7)];
    NSDictionary *lDict = [[NSDictionary alloc] initWithObjectsAndKeys:lStartPoint,@"P1",lFinishPoint,@"P2" ,lToePoint,@"P3", nil];
    [self performSelector:@selector(makeAnimation:) withObject:lDict afterDelay:1.0f];
    [lDict release];
    [lStartPoint release];
    [lFinishPoint release];
    [lToePoint release];

    [self animationStarted];

    //[self drawPlayingField];
}
#pragma mark - delegate handlers
- (void)animationStarted{
    SEL selector = @selector(animationDidStart);
    if (delegate && [delegate respondsToSelector:selector]) {
        [delegate performSelector:selector];
    }
}
- (void)animationEnded{
    SEL selector = @selector(animationDidEnd);
    if (delegate && [delegate respondsToSelector:selector]) {
        [delegate performSelector:selector];
    }
     //   [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animationEnded) object:nil];
    
    
   // [self dealloc];
}

#pragma mark - handle hints

-(void)hideSelf{
    CGPoint lSelfCenterPoint;
    if([deviceType() isEqualToString:IPHONE]){
        CGFloat lOffset = 0.0f;
        if(IS_IPHONE_5){
            lOffset = 0.5f * IPHONE5_DIFF;
        }
        lSelfCenterPoint = CGPointMake(160.0f, 720.0f+60.0f+lOffset);//720=480+480/2
    }else if([deviceType() isEqualToString:IPAD]){
        lSelfCenterPoint = CGPointMake(384.0f, 1536.0f);//1536=1024+1024/2 384=768/2
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self setCenter:lSelfCenterPoint];
    [UIView commitAnimations];
    

}
- (void) hintPressAppear{
    [mHint setTitle:NSLocalizedString(@"Press and...", @"AnimationDoc") forState:UIControlStateNormal];
    [self addSubview:mHint];
}

- (void)hintMoveAppear{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [mHint setTitle:NSLocalizedString(@"Move", @"AnimationDoc") forState:UIControlStateNormal];
    //[mHint setFrame:CGRectMake(80, 40, 150, 80)];
    [self addSubview:mHint];
    [UIView commitAnimations];
}

- (void)hintVaitAppear{
  //  NSString *lStr = [[NSString alloc] initWithCString:"Wait for fixed" encoding:NSStringEncodingConversionAllowLossy]; //@"Wait for \nfixed"
    
    [mHint setTitle:NSLocalizedString(@"Wait for \nfixed", @"AnimationDoc") forState:UIControlStateNormal];
    //[lStr release];
    
   // [mHint setFrame:CGRectMake(80, 40, 150, 80)];
    [self addSubview:mHint];
}

-(void)hintReleaseAppear{
    [mHint setTitle:NSLocalizedString(@"Release", @"AnimationDoc") forState:UIControlStateNormal];
   //[mHint setFrame:CGRectMake(80, 40, 150, 80)];
    [self addSubview:mHint];
}

- (void)hideHint{
    [mHint setHidden:YES];
}

#pragma mark - Animation handles
- (void)makeAnimation:(NSDictionary*)pDictPoints{
   
    CGFloat x1 = ((XPoint*)[pDictPoints objectForKey:@"P1"]).x;
    CGFloat y1 = ((XPoint*)[pDictPoints objectForKey:@"P1"]).y;
    CGFloat x2 = ((XPoint*)[pDictPoints objectForKey:@"P2"]).x;
    CGFloat y2 = ((XPoint*)[pDictPoints objectForKey:@"P2"]).y;
    
    CGFloat lToeX = ((XPoint*)[pDictPoints objectForKey:@"P3"]).x;
    CGFloat lToeY = ((XPoint*)[pDictPoints objectForKey:@"P3"]).y;
    
    [self performSelector:@selector(realhandAppear) withObject:nil];
    [self performSelector:@selector(hintPressAppear) withObject:nil afterDelay:0.7f];
    [self performSelector:@selector(showRealFingerTouched) withObject:nil afterDelay:1.0f];
    
    XPoint *lPoint = [[XPoint alloc] initWithPoint:CGPointMake(x1, y1)];//5 9
    [self performSelector:@selector(putCrossOnView:) withObject:lPoint afterDelay:1.5f];
    [lPoint release];
    [self performSelector:@selector(hintMoveAppear) withObject:nil afterDelay:2.0f];
    
    XPoint * lHandPoint = [[XPoint alloc] initWithPoint:CGPointMake(x2, y2)];//5 5
    [self performSelector:@selector(handMoving:) withObject:lHandPoint afterDelay:2.5f];
    [lHandPoint release];
    
    
    
    [self performSelector:@selector(hintVaitAppear) withObject:nil afterDelay:3.2f];
    [self performSelector:@selector(blinkCross) withObject:nil afterDelay:3.5f];
    
    XPoint *lPoint3 = [[XPoint alloc] initWithPoint:CGPointMake(x2, y2)];// 5 5
    [self performSelector:@selector(putConstCross:) withObject:lPoint3 afterDelay:4.0f];
    [lPoint3 release];
    
  
    
    [self performSelector:@selector(hintReleaseAppear) withObject:nil afterDelay:4.5f];
    
    [self performSelector:@selector(hideCross) withObject:nil afterDelay:5.0f];
    
    [self performSelector:@selector(setFingerUp) withObject:nil afterDelay:5.5f];
    
    XPoint * lToePoint = [[XPoint alloc] initWithPoint:CGPointMake(lToeX, lToeY)]; // 7 2
    [self performSelector:@selector(putToeOnView:) withObject:lToePoint afterDelay:6.5f];
    [lToePoint release];
    
    XPoint * lHandPoint2 = [[XPoint alloc] initWithPoint:CGPointMake(3,8)]; // 3 8
    [self performSelector:@selector(handMoving:) withObject:lHandPoint2 afterDelay:7.0f];
    [lHandPoint2 release];
    
    [self performSelector:@selector(hideHint) withObject:nil afterDelay:7.0f];
    
    [self performSelector:@selector(hideSelf)withObject:nil afterDelay:7.5f];
    
    [self performSelector:@selector(neverShowAnimation)withObject:nil afterDelay:8.0f];
    
    [self performSelector:@selector(animationEnded) withObject:nil afterDelay:8.0f];
}

-(void)neverShowAnimation{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FIRST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideSelf) withObject:nil];
}

- (void) realhandAppear{
    CGRect lFingerAppearRect;
    if ([deviceType() isEqualToString:IPHONE]){
        lFingerAppearRect = CGRectMake(100+HAND_X_OFFSET_IPHONE, 200, HAND_WIDTH_IPHONE, HAND_HEIGHT_IPHONE);
    } else if ([deviceType() isEqualToString:IPAD]){
        lFingerAppearRect = CGRectMake(290.0f+HAND_X_OFFSET_IPAD, 500.0f, HAND_WIDTH_IPAD, HAND_HEIGHT_IPAD);
    }
    [mRealFingerImg setFrame:lFingerAppearRect];
    [self addSubview:mRealFingerImg];
}

- (void)showRealFingerTouched{
    [mRealFingerImg setHighlighted:YES];
}

- (void) handMoving:(XPoint *)pPosition{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationDelegate:self];

    CGFloat lCrossSize;
    CGFloat lHandWidth;
    CGFloat lHandHeight;
    CGFloat lDeltaX;
    CGFloat lDeltaY;
    if ([deviceType() isEqualToString:IPHONE]) {
        lCrossSize = 16.0f;
        lHandHeight = HAND_HEIGHT_IPHONE;
        lHandWidth = HAND_WIDTH_IPHONE;
        lDeltaX = 20.0f + HAND_X_OFFSET_IPHONE;
        lDeltaY = 50.0f;
    } else if ([deviceType() isEqualToString:IPAD]){
        lHandHeight = HAND_HEIGHT_IPAD;
        lHandWidth = HAND_WIDTH_IPAD;
        lCrossSize = 43.0f;
        lDeltaX = 95.0f+HAND_X_OFFSET_IPAD;
        lDeltaY = 138.0f;
    }
    [mRealFingerImg setFrame:CGRectMake([XGameBoardCell cellSize].width*pPosition.x+lDeltaX   ,[XGameBoardCell cellSize].height*pPosition.y+lDeltaY, lHandWidth,  lHandHeight) ];
    [mCross         setFrame:CGRectMake([XGameBoardCell cellSize].width*pPosition.x         ,[XGameBoardCell cellSize].height*pPosition.y, lCrossSize, lCrossSize)];
    
    [UIView commitAnimations];
}

- (void)putCrossOnView:(XPoint*)pPosition{
    CGFloat lCrossSize;
    if ([deviceType() isEqualToString:IPHONE]) {
        lCrossSize = 16.0f;
    } else if ([deviceType() isEqualToString:IPAD]){
        lCrossSize = 43.0f;
    }
    [mCross setFrame:CGRectMake([XGameBoardCell cellSize].width*pPosition.x ,[XGameBoardCell cellSize].height*pPosition.y , lCrossSize, lCrossSize) ];
    [mAnimationDocBoard addSubview:mCross];
}

- (void)hideCross{
    [mCross setHidden:YES];
}

- (void)putConstCross:(XPoint*)pPosition{
    CGFloat lCrossSize;
    if ([deviceType() isEqualToString:IPHONE]) {
        lCrossSize = 16.0f;
    } else if ([deviceType() isEqualToString:IPAD]){
        lCrossSize = 43.0f;
    }
    [mCrossSettedOnPosition setFrame:CGRectMake([XGameBoardCell cellSize].width*pPosition.x ,[XGameBoardCell cellSize].height*pPosition.y , lCrossSize, lCrossSize) ];
    [mAnimationDocBoard addSubview:mCrossSettedOnPosition];
}

- (void)putToeOnView:(XPoint*)pPosition{
    CGFloat lToeSize;
    if ([deviceType() isEqualToString:IPHONE]) {
        lToeSize = 16.0f;
    } else if ([deviceType() isEqualToString:IPAD]){
        lToeSize = 43.0f;
    }
    mToe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"board_toe@2x"]];
    [mToe setFrame:CGRectMake([XGameBoardCell cellSize].width*pPosition.x ,[XGameBoardCell cellSize].height*pPosition.y , lToeSize, lToeSize) ];
    [mAnimationDocBoard addSubview:mToe];
}

- (void)setFingerUp{
    [mRealFingerImg setHighlighted:NO];
}
#pragma mark - BlinkCrossSymbolFunks
- (void)zoomInCrossSymbol {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self];
    DLog(@"ZoomIn");
    CGFloat lResizes = 4;
    [mCross setFrame:CGRectMake(mCross.frame.origin.x-lResizes, mCross.frame.origin.y-lResizes, mCross.frame.size.width+2*lResizes, mCross.frame.size.height+2*lResizes)];
    [UIView commitAnimations];
}

- (void)zoomOutCrossSymbol {    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self];
    CGFloat lResizes = 4;
    DLog(@"ZoomOut");
    [mCross setFrame:CGRectMake(mCross.frame.origin.x+lResizes, mCross.frame.origin.y+lResizes, mCross.frame.size.width-2*lResizes, mCross.frame.size.height-2*lResizes)];
    [UIView commitAnimations];
}

- (void)blinkCross{
    [self performSelector:@selector(zoomInCrossSymbol) withObject:nil afterDelay:0.1f];
    [self performSelector:@selector(zoomOutCrossSymbol) withObject:nil afterDelay:0.2f];
}

-(void)dealloc{
    DLog(@"------dealloc-----");
    XSafeRelease(mAnimationDocBoard);
    XSafeRelease(mHandImg);
    XSafeRelease(mCross);
    XSafeRelease(mToe);
    XSafeRelease(mRealFingerImg);
    XSafeRelease(mHint);
    XSafeRelease(mCrossSettedOnPosition);

    //[delegate release];
    [super dealloc];
} 
@end

@implementation XPoint
    @synthesize x;
    @synthesize y;
- (XPoint*)initWithPoint:(CGPoint)pPoint{
    XPoint *lPoint = [XPoint new];
    lPoint.x = pPoint.x;
    lPoint.y = pPoint.y;
    return lPoint ;
}

@end
