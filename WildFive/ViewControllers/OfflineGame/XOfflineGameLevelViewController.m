//
//  XOfflineGameLevelViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XOfflineGameLevelViewController.h"
#import "XOfflineGameViewController.h"
#import "XOfflineGamePlayerVSPlayerViewController.h"
#import "Global.h"

@interface XOfflineGameLevelViewController()
//private properties
@end

@implementation XOfflineGameLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
    
    [mEasyButton setTitle:NSLocalizedString(@"Beginner", @"Levels") forState:UIControlStateNormal];
    [mMediumButton setTitle:NSLocalizedString(@"Medium", @"Levels") forState:UIControlStateNormal];
    [mHardButton setTitle:NSLocalizedString(@"Hard", @"Levels") forState:UIControlStateNormal];
    [mPlayerButton setTitle:NSLocalizedString(@"Player", @"Levels") forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -Interface interaction-
/*
 Tags:
 0 - beginer
 1 - middle
 2 - professional
 */
- (IBAction)levelSlected:(id)pSender {
    if ([pSender isKindOfClass:[UIButton class]]) {
        appDelegate.mIsOnlineGame = YES;
        NSInteger lSelectedLevel = [((UIButton*)pSender) tag]; //selected level
        XGameLevel lLevel = XGameLevelMedium;
        switch (lSelectedLevel) {
            case 0: 
                lLevel = XGameLevelEasy;
                break;
            case 1: 
                lLevel = XGameLevelMedium;
                break;
            case 2:
                lLevel = XGameLevelHard;
                break;
            case 3: {
                lLevel = XGameLevelPlayer;
                
                XOfflineGamePlayerVSPlayerViewController *lController;
                if ([deviceType() isEqualToString:IPAD]) {
                    lController = [[XOfflineGamePlayerVSPlayerViewController alloc] initWithNibName:@"XOfflineGamePlayerVSPlayerViewController_iPad" bundle:nil level:lLevel];
                } else {
                    lController = [[XOfflineGamePlayerVSPlayerViewController alloc] initWithNibName:@"XOfflineGamePlayerVSPlayerViewController" bundle:nil level:lLevel];
                }
           
                [self.navigationController pushViewController:lController animated:YES];
                [lController release];
                break;
            }
            default:
                lLevel = XGameLevelMedium;
                break;
        }
       
        if (XGameLevelPlayer != lLevel) {

            XOfflineGameViewController *lController;
            if ([deviceType() isEqualToString:IPAD]) {
                lController = [[XOfflineGameViewController alloc] initWithNibName:@"XOfflineGameViewController_iPad" bundle:nil level:lLevel];
            } else {
                lController = [[XOfflineGameViewController alloc] initWithNibName:@"XOfflineGameViewController" bundle:nil level:lLevel];
            }
            [self.navigationController pushViewController:lController animated:YES];
            [lController release];
        }
    }
}

- (void)dealloc {
    [mBackgroundImageView release];
    [mBoardImageView release];
    [mEasyButton release];
    [mMediumButton release];
    [mHardButton release];
    [mPlayerButton release];
    [super dealloc];
}

@end
