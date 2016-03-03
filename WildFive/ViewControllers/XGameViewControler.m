//
//  XGameViewControler.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/10/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//
#import <AudioToolbox/AudioServices.h>
#import <GameKit/GameKit.h> 
//#import "XGameCenterManager.h"
#import "XGameCenterManager.h"
#import "XGameViewControler.h"
#import "XPoster.h"
#import "XBot.h"
#import "XGameBoard.h"
#import "XGameBoardCell.h"
//settings
#import "XConfiguration.h"
#import "XSoundEngine.h"
#import "XCounter.h"

#define SROCE_WIN 3
#define SROCE_DRAW 1

@interface XGameViewControler()
- (void) releaseArrays;
- (BOOL) makeAnalysisAtPoint:(XBoardPoint)pPoint forPlayer:(XPlayerType)pCurrentPlayer;
- (void) highlightWinningLine:(XBoardPoint)pStartPoint line:(XLineDirection)pDirection;
//board *********************************
- (void) pushValueToBoard:(XPlayerType)pPlayer atPoint:(XBoardPoint)pPoint;
//value *********************************
- (void) addToValue:(NSInteger)pValue atPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer;
//line *********************************
- (void) addToLine:(NSInteger)pValue atPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer direction:(XLineDirection)pLineDirection;
//calc total lines
- (NSUInteger) calcTotalLinsForSize:(XBoardSize)pSize;
//restarting game
- (void)restartGame:(id)pSender;
- (void) addStars:(NSUInteger)pStarsCount position:(CGPoint)pPosition;
@end

//------------------------------------------------------------------------------------
@implementation XGameViewControler
@synthesize winner=mWinner;

- (id)initWithNibName:(NSString *)pNibNameOrNil bundle:(NSBundle *)pNibBundleOrNil level:(XGameLevel)pLevel
{
    self = [super initWithNibName:pNibNameOrNil bundle:pNibBundleOrNil];
    if (self) {
        // Custom initialization
        mLevel = pLevel;
        mBoardSize = [[XConfiguration sharedConfiguration] boardSize];
        mOwnPlayerType = XPlayerTypeCross;
        mCurrentPlayer = XPlayerTypeCross;
        mIsGameFinished = NO;
        isBoardAvailable = NO;
        mIsPlayerGame = NO;
        
        mTotalLines = [self calcTotalLinsForSize:mBoardSize];
        [self initArraysForBoardSize:mBoardSize];
        [self initWeightArrayForLevel:mLevel];
        

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Local methods

- (void) releaseArrays {
    if (mBoardArray) {
        [mBoardArray release];
        mBoardArray = nil;
    }
    if (mValueArray) {
        [mValueArray release];
        mValueArray = nil;
    }
    if (mLineArray) {
        [mLineArray release];
        mLineArray = nil;
    }
}

- (BOOL) makeAnalysisAtPoint:(XBoardPoint)pPoint forPlayer:(XPlayerType)pCurrentPlayer {
    BOOL lResult = NO;
    
    XPlayerType lPlayer = pCurrentPlayer;
    XPlayerType lOpponent = [self opponentForPlayer:pCurrentPlayer];
    
    // direction - from left to right
    for (NSUInteger mainInset = 0; mainInset < 5; mainInset++) {
        XBoardPoint lCurrentPoint = XBoardPointMake(pPoint.x - mainInset, pPoint.y);
        
        if ((1 <= (lCurrentPoint.x + 1)) && ((lCurrentPoint.x + 1) <= (mBoardSize.width - 4))) {
            
            [self addToLine:1 atPoint:lCurrentPoint player:lPlayer direction:XLineDirectionH];
            
            if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionH]) {
                mTotalLines--;
            } 
            if (5 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionH]) {
                lResult = YES;
                [self highlightWinningLine:lCurrentPoint line:XLineDirectionH];
                [self gameFinishedWinner:lPlayer];
                return lResult;
            }
            
            for (NSUInteger floatInset = 0; floatInset < 5 ; floatInset++) {
                XBoardPoint lOffsetPoint = XBoardPointMake(lCurrentPoint.x + floatInset, lCurrentPoint.y);
                
                if (0 == [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionH]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionH];
                    NSInteger lNewValue = [self weightAt:lWeightIndex + 1] - [self weightAt:lWeightIndex];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lPlayer];
                } else if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionH]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionH];
                    NSInteger lNewValue = -[self weightAt:lWeightIndex + 1];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lOpponent];
                }
            }
        }
    }
    
    // direction - from left top to bottom right
    for (NSUInteger mainInset = 0; mainInset < 5; mainInset++) {
        XBoardPoint lCurrentPoint = XBoardPointMake(pPoint.x - mainInset, pPoint.y - mainInset);
        
        if ((1 <= (lCurrentPoint.x + 1)) && ((lCurrentPoint.x + 1) <= (mBoardSize.width - 4)) && (1 <= (lCurrentPoint.y + 1)) && ((lCurrentPoint.y + 1) <= (mBoardSize.height - 4))) {
            [self addToLine:1 atPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVR];
            if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVR]) {
                mTotalLines--;
            }
            if (5 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVR]) {
                lResult = YES;
                [self highlightWinningLine:lCurrentPoint line:XLineDirectionHVR];
                [self gameFinishedWinner:lPlayer];
                return lResult;
            }
                
            for (NSUInteger floatInset = 0; floatInset < 5; floatInset++) {
                XBoardPoint lOffsetPoint = XBoardPointMake(lCurrentPoint.x + floatInset, lCurrentPoint.y + floatInset);
                
                if (0 == [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionHVR]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVR];
                    NSInteger lNewValue = [self weightAt:lWeightIndex + 1] - [self weightAt:lWeightIndex];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lPlayer];
                } else if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVR]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionHVR];
                    NSInteger lNewValue = -[self weightAt:lWeightIndex + 1];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lOpponent];
                }
            }
        }
    }
    
    // direction - from right top to bottom left
    for (NSUInteger mainInset = 0; mainInset < 5; mainInset++) {
        XBoardPoint lCurrentPoint = XBoardPointMake(pPoint.x + mainInset, pPoint.y - mainInset);
        
        if ((5 <= (lCurrentPoint.x + 1)) && ((lCurrentPoint.x + 1) <= mBoardSize.width) && (1 <= (lCurrentPoint.y + 1)) && ((lCurrentPoint.y + 1) <= (mBoardSize.height - 4))) {
            [self addToLine:1 atPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVL];
            
            if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVL]) {
                mTotalLines--;
            }
            if (5 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVL]) {
                lResult = YES;
                [self highlightWinningLine:lCurrentPoint line:XLineDirectionHVL];
                [self gameFinishedWinner:lPlayer];
                return lResult;
            }
            
            for (NSUInteger floatInset = 0; floatInset < 5; floatInset++) {
                XBoardPoint lOffsetPoint = XBoardPointMake(lCurrentPoint.x - floatInset, lCurrentPoint.y + floatInset);
                
                if (0 == [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionHVL]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVL];
                    NSInteger lNewValue = [self weightAt:lWeightIndex + 1] - [self weightAt:lWeightIndex];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lPlayer];
                } else if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionHVL]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionHVL];
                    NSInteger lNewValue = -[self weightAt:lWeightIndex + 1];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lOpponent];
                }
            }
        }
    }
    
    // direction - from top to bottom
    for (NSUInteger mainInset = 0; mainInset < 5; mainInset++) {
        XBoardPoint lCurrentPoint = XBoardPointMake(pPoint.x, pPoint.y - mainInset);
        
        if ((1 <= (lCurrentPoint.y + 1)) && ((lCurrentPoint.y + 1) <= (mBoardSize.height - 4))) {
            [self addToLine:1 atPoint:lCurrentPoint player:lPlayer direction:XLineDirectionV];
            
            if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionV]) {
                mTotalLines--;
            }
            if (5 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionV]) {
                lResult = YES;
                [self highlightWinningLine:lCurrentPoint line:XLineDirectionV];
                [self gameFinishedWinner:lPlayer];
                return lResult;
            }
            
            for (NSUInteger floatInset = 0; floatInset < 5; floatInset++) {
                XBoardPoint lOffsetPoint = XBoardPointMake(lCurrentPoint.x, lCurrentPoint.y + floatInset);
                
                if (0 == [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionV]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionV];
                    NSInteger lNewValue = [self weightAt:lWeightIndex + 1] - [self weightAt:lWeightIndex];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lPlayer];
                } else if (1 == [self lineAtPoint:lCurrentPoint player:lPlayer direction:XLineDirectionV]) {
                    NSInteger lWeightIndex = [self lineAtPoint:lCurrentPoint player:lOpponent direction:XLineDirectionV];
                    NSInteger lNewValue = -[self weightAt:lWeightIndex + 1];
                    [self addToValue:lNewValue atPoint:lOffsetPoint player:lOpponent];
                }
            }
        }
    }
    return lResult;
}

- (void) pushValueToBoard:(XPlayerType)pPlayer atPoint:(XBoardPoint)pPoint {
    [[mBoardArray objectAtIndex:pPoint.x] replaceObjectAtIndex:pPoint.y withObject:[NSNumber numberWithInteger:pPlayer]];
}

- (XPlayerType) boardAtPoint:(XBoardPoint)pPoint {
    XPlayerType lResult = [[[mBoardArray objectAtIndex:pPoint.x] objectAtIndex:pPoint.y] integerValue];
    return lResult;
}

- (void) addToValue:(NSInteger)pValue atPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer {
    NSInteger lOldValue = [self valueAtPoint:pPoint player:pPlayer];
    NSInteger lNewValue = pValue + lOldValue;
    [[[mValueArray objectAtIndex:pPoint.x] objectAtIndex:pPoint.y] replaceObjectAtIndex:pPlayer withObject:[NSNumber numberWithInteger:lNewValue]];
}

- (NSInteger) valueAtPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer {
    return [[[[mValueArray objectAtIndex:pPoint.x] objectAtIndex:pPoint.y] objectAtIndex:pPlayer] integerValue];
}

- (void) addToLine:(NSInteger)pValue atPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer direction:(XLineDirection)pLineDirection {
    NSInteger lOldValue = [self lineAtPoint:pPoint player:pPlayer direction:pLineDirection];
    NSInteger lNewValue = pValue + lOldValue;
    [[[[mLineArray objectAtIndex:pPoint.x] objectAtIndex:pPoint.y] objectAtIndex:pPlayer] replaceObjectAtIndex:pLineDirection withObject:[NSNumber numberWithInteger:lNewValue]];
}

- (NSInteger) lineAtPoint:(XBoardPoint)pPoint player:(XPlayerType)pPlayer direction:(XLineDirection)pLineDirection {
    return [[[[[mLineArray objectAtIndex:pPoint.x] objectAtIndex:pPoint.y] objectAtIndex:pPlayer] objectAtIndex:pLineDirection] integerValue];
}

- (NSInteger) weightAt:(NSUInteger)pIndex {
    return [[mWeightArray objectAtIndex:pIndex] integerValue];
}

- (void) highlightWinningLine:(XBoardPoint)pStartPoint line:(XLineDirection)pDirection {

    XBoardPoint lCurrentCell = XBoardPointMake(pStartPoint.x, pStartPoint.y);
    
    NSInteger lOffsetX = 0;
    NSInteger lOffsetY = 0;
    
    if (XLineDirectionH == pDirection) {
        lOffsetX = 1;
        lOffsetY = 0;
    } else if (XLineDirectionHVR == pDirection) {
        lOffsetX = 1;
        lOffsetY = 1;
    } else if (XLineDirectionHVL == pDirection) {
        lOffsetX = -1;
        lOffsetY = 1;
    } else if (XLineDirectionV == pDirection) {
        lOffsetX = 0;
        lOffsetY = 1;
    }
    
    for (NSUInteger cell = 0; cell < 5; cell++) {
        [mGameBoard highlightSymbolAtPosition:lCurrentCell];
        lCurrentCell.x += lOffsetX;
        lCurrentCell.y += lOffsetY;
    }
}

- (NSUInteger) calcTotalLinsForSize:(XBoardSize)pSize {
    NSUInteger lResult = 0;
    NSInteger lMinWidth = pSize.width - 4;
    NSInteger lMinHeight = pSize.height - 4;
    lResult = 2 * (pSize.width * lMinHeight + pSize.height * lMinWidth + 2 * (lMinWidth * lMinHeight));
    return lResult;
}

- (void)restartGame:(id)pSender {
    [self restartGame];
}

- (void) addStars:(NSUInteger)pStarsCount position:(CGPoint)pPosition {
    [[XCounter instance] addStars:pStarsCount];
    [self setHintCount:[XCounter instance].hintCount];
    
    CGSize lStarSize = CGSizeMake(20.0, 20.0);
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        lStarSize = CGSizeMake(40.0, 40.0);
    }
    
    NSInteger lOffset = 0;
    CGFloat lDelay = 0.0;
    BOOL lStarType = YES;
    
    for (NSUInteger index = 0; index < pStarsCount; index++) {
        UIView *lStarView = [[UIView alloc] initWithFrame:CGRectMake(pPosition.x, pPosition.y, lStarSize.width, lStarSize.height)];
        [lStarView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *lStarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-lStarSize.width, 0.0, lStarView.frame.size.width, lStarView.frame.size.height)];
        [lStarImageView setAlpha:1.0];
        [lStarImageView setBackgroundColor:[UIColor clearColor]];
        if (lStarType) {
            lStarType = NO;
            [lStarImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_yellow_%@.png", deviceType()]]];
        } else {
            lStarType = YES;
            [lStarImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_gray_%@.png", deviceType()]]];
        }
        [lStarView addSubview:lStarImageView];
        [self.view addSubview:lStarView];
        
        lDelay = index * 0.15;
        
        [UIView animateWithDuration:0.3 delay:lDelay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [lStarImageView setAlpha:1.0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:0.3 delay:lDelay options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [lStarImageView setCenter:CGPointMake(lStarImageView.center.x + lStarSize.width, lStarImageView.center.y)];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.0 delay:lDelay options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut animations:^{
            [lStarView setCenter:CGPointMake(lStarView.center.x + 60.0*lOffset, -60.0)];
            
        } completion:^(BOOL finished) {
            [lStarImageView removeFromSuperview];
            [lStarView removeFromSuperview];
        }];
        
        [lStarImageView release];
        [lStarView release];
        
        lOffset++;
        
        if (lOffset >= 3) {
            lOffset = -3;
        }
    }
    
    lDelay += 1.5;
    
//    if (pStarsCount > 0) {
//        [self.view bringSubviewToFront:mStarsView];
//        
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
//            [mStarsView setCenter:CGPointMake(mStarsView.center.x, 15.0)];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3 delay:lDelay options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
//                [mStarsView setCenter:CGPointMake(mStarsView.center.x, -20.0)];
//            } completion:^(BOOL finished) {
//            }];
//        }];
//    }
}

- (void) makeHint {
    if ([XCounter instance].hintCount > 0) {
        if (!mGameBoard.isShowingHint) {
            XBoardPoint lResult = XBoardPointMake(1, 1);
            
            if (mBoardArray && mValueArray) {
                NSInteger lMaxValue = 0;
                NSUInteger lBoardWidth = [mBoardArray count];
                NSUInteger lBoardHeight = [[mBoardArray objectAtIndex:0] count];
                CGFloat lAttackValue = 1.25;
                BOOL lIsAllEmpty = YES;
                
                XPlayerType lOpponent = [self opponentForPlayer:mOwnPlayerType];
                
                //init first value
                lMaxValue = (NSInteger)floorf([[[[mValueArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:mOwnPlayerType] integerValue] * lAttackValue) + [[[[mValueArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:lOpponent] integerValue];
                for (NSUInteger positionX = 0; positionX < lBoardWidth; positionX++) {
                    for (NSUInteger positionY = 0; positionY < lBoardHeight; positionY++) {
                        XPlayerType lBoardValue = [[[mBoardArray objectAtIndex:positionX] objectAtIndex:positionY] integerValue];
                        if (XPlayerTypeEmpty == lBoardValue) {
                            NSInteger lValue = (NSInteger)floorf([[[[mValueArray objectAtIndex:positionX] objectAtIndex:positionY] objectAtIndex:mOwnPlayerType] integerValue] * lAttackValue) + [[[[mValueArray objectAtIndex:positionX] objectAtIndex:positionY] objectAtIndex:lOpponent] integerValue];
                            if (lValue > lMaxValue) {
                                lMaxValue = lValue;
                                lResult =  XBoardPointMake(positionX, positionY);
                            }
                        } else {
                            if (lIsAllEmpty) {
                                lIsAllEmpty = NO;
                            }
                        }
                    }
                }
                if (lIsAllEmpty) {
                    lResult = XBoardPointMake((int)floorf(lBoardWidth / 2), (int)floorf(lBoardHeight / 2));
                }
            }
            [mGameBoard showHintAtPosition:lResult];
            [self setHintCount:[[XCounter instance] useHint]];
        }
    } else {
        //buy here
    }
}

#pragma mark - Global methods
- (void) initBotPlayer {
    DLog(@"initBotPlayer");
    if (mBotPlayer) {
        [mBotPlayer release];
        mBotPlayer = nil;
    }
    mBotPlayer = [[XBot alloc] init];
    [mBotPlayer setBotLevel:mLevel];
    [mBotPlayer setBotType:[self opponentForPlayer:mOwnPlayerType]];
    [mBotPlayer setBoardArray:mBoardArray];
    [mBotPlayer setValueArray:mValueArray];

}

- (void) initWeightArrayForLevel:(XGameLevel)pLevel {
    DLog(@"initWeightArrayForLevel:");
    if (mWeightArray) {
        [mWeightArray release];
        mWeightArray = nil;
    }
    if (XGameLevelHard == pLevel) {
        mWeightArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:4],
                        [NSNumber numberWithInt:20],
                        [NSNumber numberWithInt:100],
                        [NSNumber numberWithInt:500], 
                        [NSNumber numberWithInt:0], nil];
    } else if (XGameLevelMedium == pLevel) {
        mWeightArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:4],
                        [NSNumber numberWithInt:5],
                        [NSNumber numberWithInt:7],
                        [NSNumber numberWithInt:20],
                        [NSNumber numberWithInt:21],
                        [NSNumber numberWithInt:65], 
                        [NSNumber numberWithInt:2], nil];
    } else {
        mWeightArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:3],
                        [NSNumber numberWithInt:5],
                        [NSNumber numberWithInt:10],
                        [NSNumber numberWithInt:20],
                        [NSNumber numberWithInt:21],
                        [NSNumber numberWithInt:60], 
                        [NSNumber numberWithInt:5], nil];
    }
}

- (void) initArraysForBoardSize:(XBoardSize)pBoardSize {
    DLog(@"initArraysForBoardSize:");
    [self releaseArrays];
    
    mBoardArray = [[NSMutableArray alloc] init];
    mValueArray = [[NSMutableArray alloc] init];
    mLineArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger boardWidth = 0; boardWidth < pBoardSize.width; boardWidth++) {
        NSMutableArray *lSubBoardArray = [[NSMutableArray alloc] init];
        NSMutableArray *lSubValueArray = [[NSMutableArray alloc] init];
        NSMutableArray *lSubLineArray = [[NSMutableArray alloc] init];
        
        for (NSUInteger boardHeight = 0; boardHeight < pBoardSize.height; boardHeight++) {
            [lSubBoardArray addObject:[NSNumber numberWithInt:XPlayerTypeEmpty]];
            
            NSMutableArray *lSubValueArraySecond = [[NSMutableArray alloc] init];
            NSMutableArray *lSubLineArraySecond = [[NSMutableArray alloc] init];
            
            for (NSUInteger players = 0; players < 2; players++) {
                [lSubValueArraySecond addObject:[NSNumber numberWithInt:0]];
                
                NSMutableArray *lSubLineArrayThird = [[NSMutableArray alloc] init];
                
                for (NSUInteger line = 0; line < 4; line++) {
                    [lSubLineArrayThird addObject:[NSNumber numberWithInt:0]];
                }
                
                [lSubLineArraySecond addObject:lSubLineArrayThird];
                [lSubLineArrayThird release];
            }
            
            [lSubValueArray addObject:lSubValueArraySecond];
            [lSubLineArray addObject:lSubLineArraySecond];
            [lSubValueArraySecond release];
            [lSubLineArraySecond release];
        }
        
        [mBoardArray addObject:lSubBoardArray];
        [mValueArray addObject:lSubValueArray];
        [mLineArray addObject:lSubLineArray];
        [lSubBoardArray release];
        [lSubValueArray release];
        [lSubLineArray release];
    }
    [[XSoundEngine sharedEngine] playSoundStartGame];
}

- (void) initBoardWithSize:(XBoardSize)pSize {

    if (mGameBoard) {
        [mGameBoard removeFromSuperview];
        [mGameBoard release];
        mGameBoard = nil;
    }
    
    if([deviceType() isEqualToString:IPHONE]){
    
        mGameBoard = [[XGameBoard alloc] initWithFrame:CGRectMake(5.0,
                                                              70.0,
                                                              310.0, 
                                                              370.0)
                                    boardDimention:pSize];
        
    }
    else if([deviceType() isEqualToString:IPAD]){
        mGameBoard = [[XGameBoard alloc] initWithFrame:CGRectMake(10.0,
                                                                  115.0,
                                                                  748.0,
                                                                  880.0)
                                        boardDimention:pSize];
    }
    [mGameBoard setDelegate:self];
    [mGameBoard setMultipleTouchEnabled:NO];
    [self.view addSubview:mGameBoard];
    if (mOwnPlayerType == XPlayerTypeToe) {
        [self blockBoard];

    } else {

        [self unBlockBoard];
    }
}

- (void) restartGame {
    mIsGameFinished = NO;
    [mGameBoard clearBoard];
    [self initArraysForBoardSize:mBoardSize];
    mTotalLines = [self calcTotalLinsForSize:mBoardSize];
    mCurrentPlayer = XPlayerTypeCross;
    if (mOwnPlayerType == XPlayerTypeToe) {
        [self blockBoard];
    } else {
        [self unBlockBoard];
    }
}

- (void) gameFinishedWinner:(XPlayerType)pWinner {
    DLog(@"____XGameViewController_gameFinishedWinner %i",pWinner);
    mIsGameFinished = YES;
    [self blockBoard];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    XMessageView *lMessageView = [[XMessageView alloc] initWithTitle:NSLocalizedString(@"Game finished", @"GameVC")  message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Hide", @"GameVC") ];
    [lMessageView setDelegate:self];
    [lMessageView setTag:0];
    [lMessageView addButtonWithTitle:NSLocalizedString(@"YES", @"GameVC")];
    
    mWinner = pWinner;
    if (mWinner == mOwnPlayerType) {
        [lMessageView setMessage:NSLocalizedString(@"Well done. You won.\n Play again?", @"GameVC")];
        
        [[XSoundEngine sharedEngine] playSoundWonGame];
        
        if (!mIsPlayerGame) {
            CGPoint lStarPoint = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
            
            [self addStars:SROCE_WIN*(mLevel+1) position:lStarPoint];
        }
        
    } else if (mWinner == [self opponentForPlayer:mOwnPlayerType]) {
        [lMessageView setMessage:NSLocalizedString(@"Do not cheer up. Be a man.\n Try again?", @"GameVC")];
        [[XSoundEngine sharedEngine] playSoundLoseGame];
    } else {
        [lMessageView setMessage:NSLocalizedString(@"Not bad.\n Play again?", @"GameVC")];
        [[XGameCenterManager instance] submitScore:SROCE_DRAW * (mLevel + 1)];
        [[XSoundEngine sharedEngine] playSoundWonGame];
    }
    
    [lMessageView show];
    [lMessageView release];
    
    if((pWinner == 1 )&&(mLevel!=3)){
        XPoster *lFacebookPoster = [XPoster instance];
        
        
        
        DLog(@"YOU WON from %i",mLevel);
        [lFacebookPoster postOnFacebookWinForLevel:mLevel];
        //[self  displayMessageAfterWon:mLevel];
    }
}

-(void)displayMessageAfterWon:(XGameLevel)pLevel{
    NSString *lLevelStr =@"";
    switch (pLevel) {
        case 0:
            lLevelStr = @"EASY";
            break;
        case 1:
            lLevelStr = @"Medium";
            break;
        case 2:
            lLevelStr = @"Hard";
            break;
        case 3:
            lLevelStr = @"Players";
            break;
        default:
            break;
    }
    XMessageView *lMessage = [[XMessageView alloc] initWithTitle:@"Congratilations" message:[NSString stringWithFormat:@"You won from %@",lLevelStr] delegate:self cancelButtonTitle:@"Cancel"];
    [lMessage show];
    [lMessage release];
    [lLevelStr release];
}

- (BOOL) fillCellAtPoint:(XBoardPoint)pFillPoint forPlayer:(XPlayerType)pPlayer {
    BOOL lResult = NO;
    if (mBoardArray) {
        if (pFillPoint.x < [mBoardArray count]) {
            if (pFillPoint.y < [[mBoardArray objectAtIndex:pFillPoint.x] count]) {
                if ([self isEmptyCell:pFillPoint]) {
                    if ((mCurrentPlayer == mOwnPlayerType) && !mIsPlayerGame) {
                        CGPoint lStarPoint = CGPointMake([XGameBoardCell cellSize].width *(pFillPoint.x+2) + mGameBoard.frame.origin.x, [XGameBoardCell cellSize].height *pFillPoint.y + mGameBoard.frame.origin.y);
                        
                        [self addStars:1 position:lStarPoint];
                    }
                    
                    [self pushValueToBoard:pPlayer atPoint:pFillPoint];
                    [mGameBoard putSymbolAtPosition:pFillPoint];
                    lResult = [self makeAnalysisAtPoint:pFillPoint forPlayer:pPlayer];
                    if (mTotalLines <= 0) {
                        if (!lResult) {
                            [self gameFinishedWinner:XPlayerTypeEmpty];
                        }
                        lResult = YES;
                    }
                    if (!lResult) {
                        [self changeCurrentPlayer];
                    }
                }
            }
        }
    }
    
    return lResult;
}

- (BOOL) isEmptyCell:(XBoardPoint)pPoint {
    BOOL lResult = NO;
    
    XPlayerType lRealStatus = [self boardAtPoint:pPoint];
    
    if (XPlayerTypeEmpty == lRealStatus) {
        lResult = YES;
    }
    
    return lResult;
}

- (BOOL) hasBoardPoint:(XBoardPoint)pPoint {
    BOOL lResult = NO;
    
    if ((pPoint.x < mBoardSize.width) && (pPoint.y < mBoardSize.height)) {
        lResult = YES;
    }
    
    return lResult;
}

- (void) blockBoard {
    [mGameBoard setUserInteractionEnabled:NO];
}

- (void) unBlockBoard {
    [mGameBoard setUserInteractionEnabled:YES];
}

- (XPlayerType) currentOpponent {
    XPlayerType lOpponent = XPlayerTypeEmpty;
    if (XPlayerTypeCross == mCurrentPlayer) {
        lOpponent = XPlayerTypeToe;
    } else if (XPlayerTypeToe == mCurrentPlayer) {
        lOpponent = XPlayerTypeCross;
    }
    return lOpponent;
}

- (XPlayerType) currentPlayer {
    return mCurrentPlayer;
}

- (XPlayerType) opponentForPlayer:(XPlayerType)pPlayer {
    XPlayerType lOpponent = XPlayerTypeEmpty;
    if (XPlayerTypeCross == pPlayer) {
        lOpponent = XPlayerTypeToe;
    } else if (XPlayerTypeToe == pPlayer) {
        lOpponent = XPlayerTypeCross;
    }
    return lOpponent;
}

- (void) changeCurrentPlayer {
    mCurrentPlayer = [self currentOpponent];
    if (mCurrentPlayer == mOwnPlayerType) {
        [self unBlockBoard];
    } else {
        [self blockBoard];
    }
}

#pragma mark - Message View Delegate's Methods
- (void) messageView:(XMessageView *)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex {
    if (pMessageView.tag == 0) {
        if (0 == pButtonIndex) {
            [self restartGame];
        }
        [self hideAnimationView];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [mAnimationDocView stopAnimation];
        [self performSelector:@selector(initBoardWithSizeWithPerformSelector) withObject:nil afterDelay:13.0f];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(initBoardWithSizeWithPerformSelector) object:nil];
    }
}

- (void) messageViewCancelButtonPressed:(XMessageView *)pMessageView {
    if (pMessageView == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) messageView:(XMessageView*)pMessageView endEditingTextField:(NSString*)pTextValue {
    
}

#pragma mark - AnimationView handlers
-(void)hideAnimationView{
    CGPoint lSelfCenterPoint;
    if([deviceType() isEqualToString:IPHONE]){

        lSelfCenterPoint = CGPointMake(320.0f/2, 480.0f+480.0f/2);
    }else if([deviceType() isEqualToString:IPAD]){
        lSelfCenterPoint = CGPointMake(768.0f/2, 1024.0f+1024.0f/2);
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [mAnimationDocView setCenter:lSelfCenterPoint];
    [UIView commitAnimations];
    [self performSelector:@selector(initBoardWithSizeFunk)withObject:nil afterDelay:1.0f];
    isBoardAvailable=YES;
}

- (void) initBoardWithSizeWithPerformSelector{
    if(isBoardAvailable==NO){
        [self performSelector:@selector(initBoardWithSizeFunk) withObject:nil];
    }
}

- (void) initBoardWithSizeFunk{
    [self initBoardWithSize:mBoardSize];
}

- (void) hideDocAnimationView{
    CGRect lAnimationDocViewRect;

    if ([deviceType() isEqualToString:IPHONE]) {
        lAnimationDocViewRect = CGRectMake(10.0f, 480.0f, 300.0f, 350.0f);
    } else if ([deviceType() isEqualToString:IPAD]) {
        lAnimationDocViewRect = CGRectMake(10.0f, 1024.0f, 748.0f, 1000.0f);
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    
    [mAnimationDocView setFrame:lAnimationDocViewRect];
    XSafeRelease(mAnimationDocView);
    [UIView commitAnimations];
}

-(void)showAnimatedDoc{
    CGPoint lAnimationDocViewRect;
    if ([deviceType() isEqualToString:IPHONE]) {
        CGFloat lOffset = 0.0f;
        if(IS_IPHONE_5){
            lOffset =  0.5f * IPHONE5_DIFF;
        }
        lAnimationDocViewRect = CGPointMake(160.0f, 270.0f+lOffset);
    } else if ([deviceType() isEqualToString:IPAD]){
        lAnimationDocViewRect = CGPointMake(384.0f, 565.0f);
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7f];
    [mAnimationDocView setCenter:lAnimationDocViewRect];
    [UIView commitAnimations];

}
#pragma mark - AnimationView delegate methods
- (void)animationDidStart{
    DLog(@"animationDidStart_inGameVC");
}
- (void)animationDidEnd{
    DLog(@"animationDidEnd_inGameVC");
}
#pragma mark - View lifecycle
- (void)loadView {
    [super loadView];
    if((ANIMATION_ON_STARTUP == NO)&&(appDelegate.mIsOnlineGame==YES)){
        BOOL isSecondaryLoading = [[NSUserDefaults standardUserDefaults] boolForKey:IS_FIRST];
        DLog(@"IS_Secondary_LOADING........ = %i",isSecondaryLoading);                            
        
        if (isSecondaryLoading==YES){                                                            
            [self initBoardWithSizeFunk];
            DLog(@"SECOND_LOADING........");
        }else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FIRST];
            CGRect lAnimationDocViewRect;
            CGFloat lOffSet = 0.0f;
            if([deviceType() isEqualToString:IPHONE]){
                if(IS_IPHONE_5){
                    lOffSet = IPHONE5_DIFF;
                }
                lAnimationDocViewRect = CGRectMake(10.0f, 480.0f, 300.0f, 400.0f+lOffSet);
            }else if([deviceType() isEqualToString:IPAD]){
                lAnimationDocViewRect = CGRectMake(14.0f, 1024.0f, 740.0f, 890.0f);
                ////AnimRect = CGRectMake(14.0f, 120.0f, 740.0f, 890.0f);
            }
            mAnimationDocView = [[XAnimationDoc alloc] initWithFrame:lAnimationDocViewRect];
            [self.view addSubview:mAnimationDocView];
            mAnimationDocView.delegate =self;
            [self performSelector:@selector(showAnimatedDoc) withObject:nil afterDelay:0.1f];
            XMessageView *lMessage = [[XMessageView alloc] initWithTitle:NSLocalizedString(@"Message:",@"GameVC") message:NSLocalizedString(@"Do you want to skip tutorial?", @"GameVC")  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"GameVC")];
            [lMessage addButtonWithTitle:NSLocalizedString(@"YES", @"GameVK")];
            [lMessage setPosition:XMessageViewPositionBottom];
            [lMessage show];
            lMessage.delegate = self;
            [lMessage release];

            [lMessage performSelector:@selector(hide) withObject:nil afterDelay:8.5f];

            [self performSelector:@selector(initBoardWithSizeWithPerformSelector) withObject:nil afterDelay:9.5f];
            DLog(@"FIRST__LOADING.........");
        }
    }else {
       [self initBoardWithSizeFunk];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!mIsPlayerGame) {
        [self showHintButton];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self hideHintButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) hintNavigationButtonPressed:(id)pSender {
    DLog(@"hintNavigationButtonPressed_XGameViewController");
    
    if (!mIsGameFinished && (mCurrentPlayer == mOwnPlayerType)) {
        [super hintNavigationButtonPressed:pSender];
        [self makeHint];
    }
}


#pragma mark - Dealloc
- (void) dealloc {
    [self releaseArrays];
    if (mBotPlayer) {
        [mBotPlayer release];
        mBotPlayer = nil;
    }
    if (mWeightArray) {
        [mWeightArray release];
        mWeightArray = nil;
    }
    [mGameBoard release];
    XSafeRelease(mAnimationDocView);
    [super dealloc];
}

#pragma mark - XGameBoardDelegate -
- (void) boardViewPushAt:(XBoardPoint) pPosition {
}

- (XPlayerType)gameboardCurrentPlayer {
    return [self currentPlayer];
}



@end





