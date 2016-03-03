//
//  XBluetoothGamesTable.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 21/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XBluetoothGamesTable.h"
#import "XBluetoothGamesTableDelegate.h"


@interface XBluetoothGamesTable()
- (void) createButtonPressed:(id)pSender;
- (void) connectButtonPressed:(id)pSender;
@end
@implementation XBluetoothGamesTable
@synthesize delegate=mDelegate;
@synthesize arrayOfGames=mArrayOfGames;
@synthesize tableViewGames=mTableViewGames;

#pragma mark - Init -
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        mArrayOfGames = [[NSMutableArray alloc] init];
        
        mCreateButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 40)];
        [mCreateButton setBackgroundColor:[UIColor blackColor]];
        [mCreateButton setTitle:@"Create" forState:UIControlStateNormal];
        [mCreateButton addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        mConnectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 75, 5, 70, 40)];
        [mConnectButton setBackgroundColor:[UIColor blackColor]];
        [mConnectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [mConnectButton addTarget:self action:@selector(connectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        mTableViewGames = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, frame.size.height - 50) style:UITableViewStylePlain];
        [mTableViewGames setDataSource:self];
        [mTableViewGames setDelegate:self];
        
        [self addSubview:mTableViewGames];
        [self addSubview:mConnectButton];
        [self addSubview:mCreateButton];
    }
    return self;
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

#pragma mark - Private methods -
- (void) createButtonPressed:(id)pSender {
    if (mDelegate) {
        if ([mDelegate respondsToSelector:@selector(bluetoothGamesTableCreatePressed:)]) {
            [mDelegate bluetoothGamesTableCreatePressed:pSender];
        } else {
            DLog(@"Not found selector");
        }
    } else {
        DLog(@"Not found delegate");
    }
}

- (void) connectButtonPressed:(id)pSender {
    DLog(@"createButtonPressed");
    NSUInteger lSelectedRow = [mTableViewGames indexPathForSelectedRow].row;
    
    if (mDelegate && ([mArrayOfGames count] > 0)) {
        if ([mDelegate respondsToSelector:@selector(bluetoothGamesTableConnectPressed:withPeerID:)]) {
            [mDelegate bluetoothGamesTableConnectPressed:pSender withPeerID:[mArrayOfGames objectAtIndex:lSelectedRow]];
        } else {
            DLog(@"Not found selector");
        }
    } else {
        DLog(@"Not found delegate");
    }
}

#pragma mark - Table View delegate -

#pragma mark - Table View data source -
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"games";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [mArrayOfGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    NSString *lGameName = @"";
    if (mSession != nil) {
        lGameName = [NSString stringWithString:[mSession displayNameForPeer:[mArrayOfGames objectAtIndex:indexPath.row]]];
    }
     
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = lGameName;
	
    return cell;
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
                [mArrayOfGames addObject:lPeerID];
                [mTableViewGames reloadData];                
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
                    [mTableViewGames reloadData];
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

#pragma mark - Reloaded methods -
- (void) setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
//        [mArrayOfGames removeAllObjects];
//        [mTableViewGames reloadData];
        [self releaseSession];
    } else {
        [self initSession];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Dealloc -
- (void) dealloc {
    [self releaseSession];
    if (mTableViewGames) {
        [mTableViewGames release];
    }
    if (mCreateButton) {
        [mCreateButton release];
    }
    if (mConnectButton) {
        [mConnectButton release];
    }
    if (mArrayOfGames) {
        [mArrayOfGames release];
    }
    [super dealloc];
}
@end
