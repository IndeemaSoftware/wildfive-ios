//
//  EEListOfGamesViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEListOfGamesViewController.h"
#import "EEGameTableViewCell.h"
#import "EELocalConnectionManager.h"
#import "EEGCConnectionManager.h"
#import "EEConnectionManagerDelegate.h"

#import "EEGameViewController.h"
#import "EEOnlineGameController.h"
#import "EELocalGameConnection.h"

@interface EEListOfGamesViewController() <UITableViewDataSource, UITableViewDelegate, EEConnectionManagerDelegate> {
    IBOutlet UITableView *_tableView;
    
    EEGCConnectionManager *_GCConnectionManager;
    EELocalConnectionManager *_localConnection;
}

- (void)startBrowsing;
- (void)stopBrowsing;

- (UITableViewCell*)getGameCellForIndexPath:(NSIndexPath*)indexPath;

- (EEGCConnectionManager*)GCConnectionManager;
- (EELocalConnectionManager*)localConnection;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)hostGameButtonPressed:(id)sender;

@end

@implementation EEListOfGamesViewController

#pragma mark - Public methods
- (instancetype)initWithListType:(EEListType)listType {
    self = [super initWithNibName:@"EEListOfGamesViewController" bundle:nil];
    if (self) {
        _listType = listType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"EEGameTableViewCell" bundle:nil] forCellReuseIdentifier:sGameTableViewCellId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startBrowsing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopBrowsing];
}

- (void)dealloc {
    [self stopBrowsing];
}

#pragma mark - Private methods
- (void)startBrowsing {
    if (self.listType == EEListTypeLocal) {
        [self.localConnection startBrowsing];
        [self.localConnection startAdvertiser];
    } else {
        [self.GCConnectionManager startBrowsing];
    }
}

- (void)stopBrowsing {
    if (self.listType == EEListTypeLocal) {
        [self.localConnection stopAdvertiser];
        [self.localConnection stopBrowsing];
    } else {
        [self.GCConnectionManager stopBrowsing];
    }
}

- (UITableViewCell*)getGameCellForIndexPath:(NSIndexPath*)indexPath {
    if (self.listType == EEListTypeLocal) {
        EEGameTableViewCell *lCell = [_tableView dequeueReusableCellWithIdentifier:sGameTableViewCellId forIndexPath:indexPath];
        
        MCPeerID *lPeerId = self.localConnection.browsedPeers[indexPath.row];
        
        lCell.gameName = [lPeerId displayName];
        
        return lCell;
    } else {
        EEGameTableViewCell *lCell = [_tableView dequeueReusableCellWithIdentifier:sGameTableViewCellId forIndexPath:indexPath];
        
        GKPlayer *lPlayer = self.GCConnectionManager.browsedPlayers[indexPath.row];
        
        lCell.gameName = lPlayer.alias;
        
        return lCell;
    }
    
    return nil;
}

- (EEGCConnectionManager*)GCConnectionManager {
    if (_GCConnectionManager == nil) {
        _GCConnectionManager = [[EEGCConnectionManager alloc] init];
        [_GCConnectionManager setDelegate:self];
    }
    return _GCConnectionManager;
}

- (EELocalConnectionManager*)localConnection {
    if (_localConnection == nil) {
        _localConnection = [[EELocalConnectionManager alloc] init];
        [_localConnection setDelegate:self];
    }
    return _localConnection;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hostGameButtonPressed:(id)sender {
    if (self.listType == EEListTypeLocal) {
    } else {
        [self.GCConnectionManager startAdvertiser];
    }
}

#pragma mark - UITableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listType == EEListTypeLocal) {
        return self.localConnection.browsedPeers.count;
    } else {
        return self.GCConnectionManager.browsedPlayers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getGameCellForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.listType == EEListTypeLocal) {
        [self.localConnection sendInvitationToPeer:self.localConnection.browsedPeers[indexPath.row]];
    } else {
        [self.GCConnectionManager invitePllayer:self.GCConnectionManager.browsedPlayers[indexPath.row]];
    }
}

#pragma mark - EEConnectionManagerDelegate
- (void)EEConnectionManagerBrowserUpdatePeers {
    [_tableView reloadData];
}

- (void)EEConnectionManagerEstablishedConnection:(EEEsteblishedConnection *)connection {
    [self.localConnection stopAdvertiser];
    
    EEOnlineGameController *lGameController = [[EEOnlineGameController alloc] initWithConnection:[EELocalGameConnection gameConnectionWith:connection]];
    
    dispatch_async(dispatch_get_main_queue(),^{
        EEGameViewController *lGameViewController = [[EEGameViewController alloc] initWithGame:lGameController];
        [self.navigationController pushViewController:lGameViewController animated:YES];
    });
}

@end
