//
//  XSelectBluetoothGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XSelectBluetoothGameViewController.h"
#import "XBluetoothGameViewController.h"

@interface XSelectBluetoothGameViewController ()

- (IBAction) createButtonPressed:(id)pSender;
- (void) initSession;
- (void) releaseSession;
- (void) showMessageCreateGame;
@end

@implementation XSelectBluetoothGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mArrayOfGames = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Private methods -
- (void) createButtonPressed:(id)pSender {
    XSafeRelease(mNewGameName);
    [self showMessageCreateGame];
}

- (void) initSession {
    if (mSession == nil) {
        //init session for board
        mSession = [[GKSession alloc] initWithSessionID:@"WildFiveBluetoothGame" displayName:@"BluetoothGames" sessionMode:GKSessionModeClient];
        [mSession setDelegate:self];
        [mSession setDataReceiveHandler:self withContext:nil];
        mSession.available = YES;
    }
}

- (void) releaseSession {
    if (mSession != nil) {
        mSession.available = NO;
        [mSession setDataReceiveHandler: nil withContext: nil];
        mSession.delegate = nil;
        [mSession release];
        mSession = nil;
    }
    if (mArrayOfGames != nil) {
        [mArrayOfGames removeAllObjects];
    }
    [mTableViewGames reloadData];
}

- (void) showMessageCreateGame {
    XMessageView *lCreateNewGameMeesage = [[XMessageView alloc] initWithTitle:NSLocalizedString(@"Create new game", @"selectBluetoothVC")  message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"selectBluetoothVC")];
    [lCreateNewGameMeesage addButtonWithTitle:NSLocalizedString(@"Create", @"selectBluetoothVC")];
    [lCreateNewGameMeesage addTextFieldWithPlaceHolder:NSLocalizedString(@"name", @"selectBluetoothVC")];
    [lCreateNewGameMeesage setPosition:XMessageViewPositionCenter];
    [lCreateNewGameMeesage setTag:0];
    [lCreateNewGameMeesage show];
    [lCreateNewGameMeesage release];
}

- (void)rightNavigationButtonPressed:(id)pSender {
    [self createButtonPressed:pSender];
}

#pragma mark - Table View -
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([deviceType() isEqualToString:IPAD]) {
        return 87;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([mArrayOfGames count] == 0) {
        [mNoGamesLabel setHidden:NO];
    } else {
        [mNoGamesLabel setHidden:YES];
    }
	return [mArrayOfGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XSelectBluetoothTableViewCell";
    NSString *lGameName = @"";
    if (mSession != nil) {
        lGameName = [NSString stringWithString:[mSession displayNameForPeer:[mArrayOfGames objectAtIndex:indexPath.row]]];
    }
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *lCells = [[NSBundle mainBundle] loadNibNamed:@"XSelectBluetoothTableViewCell" owner:nil options:nil];
        cell = [lCells objectAtIndex:0];
    }
	cell.textLabel.text = lGameName;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger lSelectedRow = indexPath.row;
    if (([mArrayOfGames count] > 0) && (lSelectedRow != -1)) {
        NSDictionary *lOptions = [NSDictionary dictionaryWithObjectsAndKeys:CONNECT, OPTION_TYPE, [mArrayOfGames objectAtIndex:lSelectedRow], OPPONENT_PEER_ID, nil];
        XBluetoothGameViewController *lController;
        if ([deviceType() isEqualToString:IPAD]) {
            lController = [[XBluetoothGameViewController alloc] initWithNibName:@"XBluetoothGameViewController_iPad" bundle:nil options:lOptions];
        } else {
            lController = [[XBluetoothGameViewController alloc] initWithNibName:@"XBluetoothGameViewController" bundle:nil options:lOptions];
        }
        
        [self.navigationController pushViewController:lController animated:YES];

        [lController release];
        //XSafeRelease(lOptions);
    }
}

#pragma mark - Session delegate -
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state) {
        case GKPeerStateAvailable: {
            DLog(@"GKPeerStateAvailable = %@", peerID);
            NSString *lPeerID = [NSString stringWithString:peerID];
            
            BOOL lIsPeerInArray = NO;
            for (NSUInteger peer = 0; peer < [mArrayOfGames count]; peer++) {
                NSString *lPeerFromArray = [mArrayOfGames objectAtIndex:peer];
                if ([lPeerFromArray isEqualToString:lPeerID]) {
                    lIsPeerInArray = YES;
                    break;
                }
            }
            if (!lIsPeerInArray) {
                [mArrayOfGames insertObject:lPeerID atIndex:0];
                [mTableViewGames insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                
            }
            break;
        }
        case GKPeerStateUnavailable: {
            DLog(@"GKPeerStateUnavailable = %@", peerID);
            NSString *lPeerID = [NSString stringWithString:peerID];
            
            for (NSUInteger peer = 0; peer < [mArrayOfGames count]; peer++) {
                NSString *lPeerFromArray = [mArrayOfGames objectAtIndex:peer];
                if ([lPeerFromArray isEqualToString:lPeerID]) {
                    [mArrayOfGames removeObjectAtIndex:peer];
                    [mTableViewGames deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:peer inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
} 

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
}

- (BOOL)acceptConnectionFromPeer:(NSString *)peerID error:(NSError **)error {
    return YES;
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
}

#pragma mark - message View delegate's methods
- (void) messageView:(XMessageView *)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex {
    if (0 == [pMessageView tag]) {
        if (mNewGameName == nil) {
            mNewGameName = [[NSString stringWithFormat:NSLocalizedString(@"new game", "SelectBluetoothVC") ] retain];
        }
        
        NSDictionary *lOptions = [NSDictionary dictionaryWithObjectsAndKeys:CREATE_GAME, OPTION_TYPE, mNewGameName, GAME_NAME, nil];
        XBluetoothGameViewController *lController;
        if ([deviceType() isEqualToString:IPAD]) {
            lController = [[XBluetoothGameViewController alloc] initWithNibName:@"XBluetoothGameViewController_iPad" bundle:nil options:lOptions];
        } else {
            lController = [[XBluetoothGameViewController alloc] initWithNibName:@"XBluetoothGameViewController" bundle:nil options:lOptions];
        }
        
        [self.navigationController pushViewController:lController animated:YES];

        [lController release];
        //XSafeRelease(lOptions);
    }
}

- (void) messageViewCancelButtonPressed:(XMessageView *)pMessageView {

}

- (void) messageView:(XMessageView*)pMessageView endEditingTextField:(NSString*)pTextValue {
    XSafeRelease(mNewGameName);
    if (pTextValue != nil) {
        if ([pTextValue length] != 0) {
            mNewGameName = [[NSString alloc] initWithString:pTextValue];
        } else {
            mNewGameName = [[NSString alloc] initWithString:NSLocalizedString(@"new game", "SelectBluetoothVC")];
        }
    } else {
        mNewGameName = [[NSString alloc] initWithString:NSLocalizedString(@"new game", "SelectBluetoothVC")];
    }
}

#pragma mark - View life -
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
    
    [mNoGamesLabel setText:NSLocalizedString(@"No Games", @"SelectBluetoothVC")];
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
    [self setRightButtonTitle:NSLocalizedString(@"Create", @"SelectBluetooth")];
    [self showBackButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initSession];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self releaseSession];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    XSafeRelease(mNewGameName);
    [mBackgroundImageView release];
    [mTableViewGames release];
    [mNoGamesLabel release];
    [mArrayOfGames release];
    [super dealloc];
}

@end
