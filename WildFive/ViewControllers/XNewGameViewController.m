//
//  XNewGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XNewGameViewController.h"
#import "XOfflineGameLevelViewController.h"
#import "XSelectOnlineGameViewController.h"
#import "XOnlineGameViewController.h"
#import "XSelectBluetoothGameViewController.h"

@interface XNewGameViewController()
//private properties

- (void) showMessageNoAuthentificated;
@end

@implementation XNewGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationj

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private methods
- (void) showMessageNoAuthentificated {
    XMessageView *lMessageView = [[XMessageView alloc] initWithTitle:@"Warning!" message:@"Game center disabled." delegate:nil cancelButtonTitle:@"Ok"];
    [lMessageView setPosition:XMessageViewPositionCenter];
    [lMessageView show];
    [lMessageView release];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
    
   // mCreateGameButton.titleLabel.text=NSLocalizedString(@"Create Game", @"");
    [mCreateGameButton setTitle:NSLocalizedString(@"Create Game", @"") forState:UIControlStateNormal];
    [mFindGameButton setTitle:NSLocalizedString(@"Find", @"") forState:UIControlStateNormal];
    [mOnlineGameButton setTitle:NSLocalizedString(@"Online Game", @"") forState:UIControlStateNormal];
    [mOfflineGameButton setTitle:NSLocalizedString(@"Offline", @"") forState:UIControlStateNormal];
    [mBluetoothGameButton setTitle:NSLocalizedString(@"Game Via Bluetooth", @"") forState:UIControlStateNormal];
    [mBackButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    
    
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -Interface interaction-
- (IBAction)onlineGame:(id)pSender {
    appDelegate.mIsOnlineGame = NO;

    if ([deviceType() isEqualToString:IPAD]) {
         
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
        XSelectOnlineGameViewController *lController = [[ XSelectOnlineGameViewController alloc] initWithNibName: @"XSelectOnlineGameViewController_iPad" bundle:nil ];
        [self.navigationController pushViewController:lController animated:YES];

        
        } else {
            [self showMessageNoAuthentificated];
        }
    } else {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            XSelectOnlineGameViewController *lController = [[ XSelectOnlineGameViewController alloc] initWithNibName: @"XSelectOnlineGameViewController" bundle:nil ];
            [self.navigationController pushViewController:lController animated:YES];
            
            
        } else {
            [self showMessageNoAuthentificated];
        }
    }

 
}

- (IBAction)createGameButtonPressed:(id)pSender {
    appDelegate.mIsOnlineGame = NO;

    XOnlineGameViewController *lCntroller;
    if ([deviceType() isEqualToString:IPAD]) {
        lCntroller= [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController_iPad" bundle:nil withType:XOnlineGameTypeCreate];
    } else {
        lCntroller= [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController" bundle:nil withType:XOnlineGameTypeCreate];
    }
    [self.navigationController pushViewController:lCntroller animated:YES];
    [lCntroller release];
}

- (IBAction)findGameButtonPressed:(id)pSender {
    appDelegate.mIsOnlineGame = NO;
    XOnlineGameViewController *lCntroller;
    if ([deviceType() isEqualToString:IPAD]) {
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController_iPad" bundle:nil withType:XOnlineGameTypeConnect];
    } else {
        lCntroller = [[XOnlineGameViewController alloc] initWithNibName:@"XOnlineGameViewController" bundle:nil withType:XOnlineGameTypeConnect];
    }
    [self.navigationController pushViewController:lCntroller animated:YES];
    [lCntroller release];
}

- (IBAction)offlineGame:(id)pSender {
    appDelegate.mIsOnlineGame = YES;
    XOfflineGameLevelViewController *lController;
    if ([deviceType() isEqualToString:IPAD]) {
        lController = [[XOfflineGameLevelViewController alloc] initWithNibName:@"XOfflineGameLevelViewController_iPad" bundle:nil];
        
    } else {
        lController = [[XOfflineGameLevelViewController alloc] initWithNibName:@"XOfflineGameLevelViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:lController animated:YES];

    [lController release];
}

- (IBAction) bluetoothGame:(id)pSender {
    appDelegate.mIsOnlineGame = NO;
    XSelectBluetoothGameViewController *lController;
    if ([deviceType() isEqualToString:IPAD]) {
        lController = [[XSelectBluetoothGameViewController alloc] initWithNibName:@"XSelectBluetoothGameViewController_iPad" bundle:nil];
    }else{
        lController = [[XSelectBluetoothGameViewController alloc] initWithNibName:@"XSelectBluetoothGameViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:lController animated:YES];
    [lController release];
}

- (void)dealloc {
    [mBackgroundImageView release];
    [mOnlineGameButton release];
    [mCreateGameButton release];
    [mFindGameButton release];
    [mOfflineGameButton release];
    [mBluetoothGameButton release];
    [super dealloc];
}

@end
