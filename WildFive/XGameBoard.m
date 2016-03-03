//
//  XGameBoard.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XGameBoard.h"
#import "XGameBoardCell.h"
#import "Global.h"
#import "XGameBoardView.h"
#import "XGameViewControler.h"

#define LOCK_TIME 0.25

@interface XGameBoard()
//delegate methods
- (void)pushValueAtX:(NSUInteger)pPositionX y:(NSUInteger)pPositionY;

- (XBoardPoint)positionOnField:(CGPoint) pPosition;
- (void)putSymbolOnViewOnCoordinats:(CGPoint) pPoint;
- (BOOL)isSymbolAtPosition:(XBoardPoint) pPoint;
- (CGPoint)correctedPosition:(CGPoint) pPoint;
- (BOOL)ignoreTouchAtCoordinates:(CGPoint)pPoint;
- (void)highlightSymbolAtCoordinates:(CGPoint) pPoint;

- (void)lockSymbolAtCurrentPosition;
@end

@implementation XGameBoard

@synthesize currentPlayer=mCurrentPlayer;
@synthesize dataSource=mDataSource;
@synthesize delegate=mDelegate;

#pragma mark - Private methods -

- (void) pushValueAtX:(NSUInteger)pPositionX y:(NSUInteger)pPositionY {
    if (mDelegate != nil) {
        if ([mDelegate respondsToSelector:@selector(boardViewPushAt:)]) {
            [mDelegate boardViewPushAt:XBoardPointMake(pPositionX, pPositionY)];
        } else {
            NSLog(@"game delagate not found selector");
        }
    } else {
        NSLog(@"Game delegate has not been found  ");
    }
    if (mCurrentCell != nil) {
        [mCurrentCell release];
        mCurrentCell = nil;
    }
}

- (XBoardPoint)positionOnField:(CGPoint) pPosition {
    XBoardPoint lPoint;
    
    lPoint.x = (int)(pPosition.x / [XGameBoardCell cellSize].width);
    lPoint.y = (int)(pPosition.y / [XGameBoardCell cellSize].height);
    
    return lPoint;
}

- (BOOL)isSymbolAtPosition:(XBoardPoint) pPoint {
    BOOL lResult = NO;
    
    for (UIView *lView in [mGameBoardView subviews]) {
        if ([lView isKindOfClass:[XGameBoardCell class]]) {
            if ((((XGameBoardCell*)lView).symbolPosition.x == pPoint.x) && (((XGameBoardCell*)lView).symbolPosition.y == pPoint.y)) {
                lResult = YES;
                break;
            }
        }
    }
    
    return lResult;
}

- (CGPoint)correctedPosition:(CGPoint)pPoint {
    return CGPointMake(pPoint.x - mGameBoardView.frame.origin.x, pPoint.y - 4.0 * [XGameBoardCell cellSize].height - mGameBoardView.frame.origin.y);
}

- (void)highlightSymbolAtCoordinates:(CGPoint) pPoint {
    NSInteger lX = (int)(pPoint.x / [XGameBoardCell cellSize].width);
    NSInteger lY = (int)( pPoint.y / [XGameBoardCell cellSize].height);

    [self highlightSymbolAtPosition:XBoardPointMake(lX, lY)];
}

- (void)lockSymbolAtCurrentPosition {
    mIsSymbolLocked = YES;
    mLockSymbolTimer = nil;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    for (int i=0; i<2;i++) {
        mCurrentCell.frame = CGRectMake(mCurrentCell.frame.origin.x - 1.5, 
                                        mCurrentCell.frame.origin.y - 1.5, 
                                        mCurrentCell.frame.size.width + 3.0, 
                                        mCurrentCell.frame.size.height + 3.0);
        
        mCurrentCell.frame = CGRectMake(mCurrentCell.frame.origin.x + 1.5, 
                                        mCurrentCell.frame.origin.y + 1.5, 
                                        mCurrentCell.frame.size.width - 3.0, 
                                        mCurrentCell.frame.size.height - 3.0);
    }
    
    [UIView commitAnimations];
}

- (BOOL)ignoreTouchAtCoordinates:(CGPoint)pPoint {
    BOOL lResult = NO;
    CGFloat lFault = 5.0;
    
    if ((mCurrentCell.frame.origin.x - lFault <= pPoint.x) &&
        (mCurrentCell.frame.origin.y - lFault <= pPoint.y) &&
        (mCurrentCell.frame.origin.x + mCurrentCell.frame.size.width + lFault >= pPoint.x) &&
        (mCurrentCell.frame.origin.y + mCurrentCell.frame.size.height + lFault >= pPoint.y)) {
        lResult = YES;
    }
    
    return lResult;
}

#pragma mark - Public methods -

- (void)highlightSymbolAtPosition:(XBoardPoint) pPoint {
    
    for (UIView *lView in [mGameBoardView subviews]) {
        if ([lView isKindOfClass:[XGameBoardCell class]]) {
            if ((((XGameBoardCell*)lView).symbolPosition.x == pPoint.x) && (((XGameBoardCell*)lView).symbolPosition.y == pPoint.y)) {
                //puth highlighting code here
                lView.backgroundColor = [UIColor redColor];
            }
        }
    }
}

- (void)putSymbolOnViewOnPosition:(XBoardPoint) pPoint {
    if (mDelegate) {
        if ([mDelegate respondsToSelector:@selector(gameboardCurrentPlayer)]) {
            XGameBoardCell *lCell = [[XGameBoardCell alloc] initWithFrame:CGRectMake([XGameBoardCell cellSize].width *pPoint.x + 1.0, 
                                                                             [XGameBoardCell cellSize].height *pPoint.y + 1.0, [XGameBoardCell cellSize].width, [XGameBoardCell cellSize].height)];
            lCell.symbolPosition = XBoardPointMake(pPoint.x, pPoint.y);
            lCell.currentUser = [mDelegate gameboardCurrentPlayer];
            [mGameBoardView addSubview:lCell];
            if (mCurrentCell != nil) {
                [mCurrentCell release];
                mCurrentCell = nil;
            }
            mCurrentCell = [lCell retain];
            [lCell release];
        }
    } else {
        DLog(@"->Warning!<-  Delegate for XGameBoard was not set");
    }
}

- (void)putSymbolOnViewOnCoordinats:(CGPoint) pPoint {
    XBoardPoint lPosition = [self positionOnField:pPoint];
    DLog(@"Symbols count:   x:%i  y:%i", lPosition.x,lPosition.y);
    
    if ((mGameBoardView.frame.size.width < pPoint.x) || (mGameBoardView.frame.size.height < pPoint.y) || (pPoint.x < 0.0) || (pPoint.y < 0.0)){
        return;
    }
    
    [self putSymbolOnViewOnPosition:XBoardPointMake((int)lPosition.x, (int)lPosition.y)];
}

//remove all symbols from board
- (BOOL) clearBoard {
    BOOL lResult = NO;
    
    for (UIView *lView in [mGameBoardView subviews]) {
        if ([lView isKindOfClass:[XGameBoardCell class]]) {
            [lView removeFromSuperview];
        }
    }
    
    if ([[mGameBoardView subviews] count] == 0) {
        lResult = YES;
    }
    
    return lResult;
}

#pragma mark - Initialization -

- (id) initWithFrame:(CGRect) pFrame {
    self = [super initWithFrame:pFrame];
    if (self) {
        mLockSymbolTimer = nil;
        mIsSymbolLocked = NO;
        
        mBoardSize.width = DEFAULT_BOARD_SIZE;
        mBoardSize.height = DEFAULT_BOARD_SIZE;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentSize = CGSizeMake([XGameBoardCell cellSize].width * DEFAULT_BOARD_SIZE, [XGameBoardCell cellSize].height * DEFAULT_BOARD_SIZE);
        mGameBoardView = [[XGameBoardView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.contentSize.width) / 2.0, 
                                                                          (self.frame.size.height - self.contentSize.height) / 2.0, 
                                                                          self.contentSize.width, 
                                                                          self.contentSize.height) 
                                                 withBoardSize:mBoardSize];
        [self addSubview:mGameBoardView];
    }
    
    return self;
}

- (id) initWithFrame:(CGRect) pFrame boardDimention:(XBoardSize) pBoardSize {
    self = [super initWithFrame:pFrame];
    if (self) {
        mBoardSize = pBoardSize;

        self.backgroundColor = [UIColor clearColor];
        
        self.contentSize = CGSizeMake([XGameBoardCell cellSize].width * pBoardSize.width, [XGameBoardCell cellSize].height * pBoardSize.height);
        mGameBoardView = [[XGameBoardView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.contentSize.width) / 2.0, 
                                                                          (self.frame.size.height - self.contentSize.height) / 2.0, 
                                                                          self.contentSize.width, 
                                                                          self.contentSize.height) 
                                                 withBoardSize:mBoardSize];
//        mGameBoardView = [[XGameBoardView alloc] initWithFrame:CGRectMake(0.0,
//                                                                          0.0, 
//                                                                          self.contentSize.width, 
//                                                                          self.contentSize.height) 
//                                                 withBoardSize:mBoardSize];
        [self addSubview:mGameBoardView];
    }
    
    return self;
}

- (void) dealloc {
    if (mDataSource) {
        [mDataSource release];
        mDataSource = nil;
    }
    [mGameBoardView release];
    if (mCurrentCell != nil) {
        [mCurrentCell release];
        mCurrentCell = nil;
    }
    [super dealloc];
}

#pragma mark - Events handling -

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *lTouch = [[touches allObjects] objectAtIndex:0];
    mSymbolPosition = [self correctedPosition:[lTouch locationInView:self]];
    DLog(@"Location: x:%f  y:%f", [lTouch locationInView:self].x, [lTouch locationInView:self].y);
    
    if (mCurrentCell != nil) {
        [mCurrentCell release];
        mCurrentCell = nil;
    }
    VKSafeTimerRelease(mLockSymbolTimer);
    mLockSymbolTimer = [NSTimer scheduledTimerWithTimeInterval:LOCK_TIME
                                                        target:self 
                                                      selector:@selector(lockSymbolAtCurrentPosition) 
                                                      userInfo:nil
                                                       repeats:NO];
    
    [self putSymbolOnViewOnCoordinats:mSymbolPosition]; 
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *lTouch = [[touches allObjects] objectAtIndex:0];
    
    CGPoint lPosition = [self correctedPosition:[lTouch locationInView:self]];
    
    if (![self ignoreTouchAtCoordinates:lPosition]) {
        if (mCurrentCell != nil) {
            if ([mCurrentCell superview]) {
                [mCurrentCell removeFromSuperview];
            }
            DLog(@"---->Count: %i", [mCurrentCell retainCount]);
        }
        mSymbolPosition = lPosition;
        
        VKSafeTimerRelease(mLockSymbolTimer);
        mLockSymbolTimer = [NSTimer scheduledTimerWithTimeInterval:LOCK_TIME
                                                            target:self 
                                                          selector:@selector(lockSymbolAtCurrentPosition) 
                                                          userInfo:nil
                                                           repeats:NO];
        mIsSymbolLocked = NO;

        [self putSymbolOnViewOnCoordinats:mSymbolPosition];    
        
        DLog(@"Location: x:%f  y:%f", [lTouch locationInView:self].x, [lTouch locationInView:self].y);
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {   
    if (mCurrentCell != nil) {
        if ([mCurrentCell superview]) {
            [mCurrentCell removeFromSuperview];
        }
    }
    
    if (!mIsSymbolLocked) {        
        VKSafeTimerRelease(mLockSymbolTimer);
    } else {
        NSInteger lX = (int)(mSymbolPosition.x / [XGameBoardCell cellSize].width);
        NSInteger lY = (int)(mSymbolPosition.y / [XGameBoardCell cellSize].height);
        if ((mGameBoardView.frame.size.width > mSymbolPosition.x) && (mGameBoardView.frame.size.height > mSymbolPosition.y) && (mSymbolPosition.x > 0.0) && (mSymbolPosition.y > 0.0)){
            DLog(@"X: %i  Y: %i", lX, lY);
            [self pushValueAtX:(int)lX y:(int)lY];
        }
        
        mIsSymbolLocked = NO;
        mLockSymbolTimer = nil;
    }
}

@end
