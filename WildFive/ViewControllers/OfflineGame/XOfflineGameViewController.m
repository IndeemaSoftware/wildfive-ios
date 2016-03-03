
//  XOfflineGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 16/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XOfflineGameViewController.h"

#import "XBot.h"
#import "XGameBoard.h"

@interface XOfflineGameViewController()
- (void) goBotWithProperty;
- (void) botFirstStep;
@end		
@implementation XOfflineGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil level:(XGameLevel)pLevel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil level:pLevel];
    if (self) {
        // Custom initialization
        [self initBotPlayer];
        mBotTimer = nil;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Reloaded methods
- (void) gameFinishedWinner:(XPlayerType)pWinner {
    [super gameFinishedWinner:pWinner];
    VKSafeTimerRelease(mBotTimer);
}
- (void) botFirstStep {
    NSInteger lBotX = rand() % mBoardSize.width;
    NSInteger lBotY = rand() % mBoardSize.height;
    NSDictionary *lProperty = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInteger:lBotX],
                               @"bot_point_x",
                               [NSNumber numberWithInteger:lBotY],
                               @"bot_point_y", nil];
    mBotTimer = [NSTimer scheduledTimerWithTimeInterval:1
                        target:self 
                        selector:@selector(goBotWithProperty) 
                        userInfo:lProperty
                        repeats:NO];
    [lProperty release];
}

- (void) restartGame {
    VKSafeTimerRelease(mBotTimer);
    [super restartGame];
    [self initBotPlayer];
    
    if (mOwnPlayerType == XPlayerTypeToe) {
        [self botFirstStep];
    }
}

- (void) boardViewPushAt:(XBoardPoint)pPosition {
    if ([self hasBoardPoint:pPosition]) {
        if ([self isEmptyCell:pPosition]) {
            
            BOOL lIsFinished = NO;
            lIsFinished = [self fillCellAtPoint:pPosition forPlayer:mCurrentPlayer];
            
            if (!lIsFinished) {
                XBoardPoint lBotPoint = [mBotPlayer findBestPosition];
                NSUInteger lBotValue = ABS([self valueAtPoint:lBotPoint player:mBotPlayer.botType]);
                NSUInteger lOpponentValue = ABS([self valueAtPoint:lBotPoint player:[self currentOpponent]]);
                NSInteger lValue = (lOpponentValue + lBotValue - 16) / 10;
                if (lValue <= 0) {
                    lValue = 70;
                }
                if (lValue < 3) {
                    lValue = 3;
                }
                CGFloat lTime = 7.0 / lValue;
                NSDictionary *lProperty = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:lBotPoint.x],
                                           @"bot_point_x",
                                           [NSNumber numberWithInteger:lBotPoint.y],
                                           @"bot_point_y", nil];
                mBotTimer = [NSTimer scheduledTimerWithTimeInterval:lTime
                                                             target:self 
                                                           selector:@selector(goBotWithProperty) 
                                                           userInfo:lProperty
                                                            repeats:NO];
                [lProperty release];
            }
        }
    }
}

- (void) goBotWithProperty {
    NSDictionary *pProperty = [mBotTimer userInfo];
    NSInteger lBotX = [[pProperty valueForKey:@"bot_point_x"] integerValue];
    NSInteger lBotY = [[pProperty valueForKey:@"bot_point_y"] integerValue];
    XBoardPoint lBotPoint = XBoardPointMake(lBotX, lBotY);
    [self fillCellAtPoint:lBotPoint forPlayer:mBotPlayer.botType];
    mBotTimer = nil;
}

- (void)rightNavigationButtonPressed:(id)pSender {
    [self restartGame];
}

#pragma mark - View lifecycle
- (void) loadView {
    [super loadView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (mOwnPlayerType == XPlayerTypeToe) {
        [self botFirstStep];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showRightButton];
    [self showBackButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Events handling -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Dealloc
- (void) dealloc {
    VKSafeTimerRelease(mBotTimer);
    [mBackgroundImageView release];
    [super dealloc];
}

@end
