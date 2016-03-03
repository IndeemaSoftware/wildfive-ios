//
//  XSelectOnlineGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XSelectOnlineGameViewController.h"
#import "XOnlineGameViewController.h"

@interface XSelectOnlineGameViewController()

@end
@implementation XSelectOnlineGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [mCreateGameButton setTitle:NSLocalizedString(@"Create Game", @"SelectOnlineGameVC") forState:UIControlStateNormal];
    [mFindGameButton setTitle:NSLocalizedString(@"Find", @"SelectOnlineGameVC") forState:UIControlStateNormal];
    [mPlayWithFriendButton setTitle:NSLocalizedString(@"Play with friend", @"SelectOnlineGameVC") forState:UIControlStateNormal];
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

#pragma mark - Public methods -
- (IBAction)createGameButtonPressed:(id)pSender {
    DLog(@"createGameButtonPressed________");
    XOnlineGameViewController *lCntroller;
    if ([deviceType() isEqualToString:IPAD]) {
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController_iPad" bundle:nil withType:XOnlineGameTypeCreate];

    } else{
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController" bundle:nil withType:XOnlineGameTypeCreate];
    }
    
    [self.navigationController pushViewController:lCntroller animated:YES];

    [lCntroller release];
}

- (IBAction)findGameButtonPressed:(id)pSender {
    DLog(@"findGameButtonPressed___");
    XOnlineGameViewController *lCntroller;
    if ([deviceType() isEqualToString:IPAD]) {
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController_iPad" bundle:nil withType:XOnlineGameTypeConnect];
    } else {

        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController" bundle:nil withType:XOnlineGameTypeConnect];
    }
    [self.navigationController pushViewController:lCntroller animated:YES];
    [lCntroller release];
}

- (IBAction)playWithFriendButtonPressed:(id)pSender {
    DLog(@"playWithFriendButtonPressed___");
    XOnlineGameViewController *lCntroller ;
    if ([deviceType() isEqualToString:IPAD]) {
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController_iPad" bundle:nil withType:XOnlineGameTypeFriend];
    } else {
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController" bundle:nil withType:XOnlineGameTypeFriend];
    }
    
    [self.navigationController pushViewController:lCntroller animated:YES];

    [lCntroller release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Dealloc -
- (void) dealloc {
    [mBackgroundImageView release];
    [mCreateGameButton release];
    [mFindGameButton release];
    [mPlayWithFriendButton release];
    [super dealloc];
}


@end
