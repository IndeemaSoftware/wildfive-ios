//
//  XOfflineGamePlayerVSPlayerViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 18/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XOfflineGamePlayerVSPlayerViewController.h"

@implementation XOfflineGamePlayerVSPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil level:(XGameLevel)pLevel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil level:pLevel];
    if (self) {
        // Custom initialization
        mOwnPlayerType = XPlayerTypeCross;
        mIsPlayerGame = YES;

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
}

- (void) restartGame {
    [super restartGame];
}

- (void) boardViewPushAt:(XBoardPoint)pPosition {
    if ([self hasBoardPoint:pPosition]) {
        if ([self isEmptyCell:pPosition]) {
            BOOL lIsFinished = NO;
            lIsFinished = [self fillCellAtPoint:pPosition forPlayer:mCurrentPlayer];
            if (!lIsFinished) {
                [self unBlockBoard];
            }
        }
    }
}

- (void)rightNavigationButtonPressed:(id)pSender {
    [self restartGame];
}

#pragma mark - View lifecycle
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)dealloc {
    [mBackgroundImageView release];
    [super dealloc];
}

@end
