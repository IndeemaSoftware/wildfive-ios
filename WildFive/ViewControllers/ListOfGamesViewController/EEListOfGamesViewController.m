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

#import "EEGameViewController.h"
#import "EEOnlineGameController.h"
#import "EELocalGameConnection.h"

@interface EEListOfGamesViewController() <UITableViewDataSource, UITableViewDelegate, EELocalConnectionManagerDelegate> {
    IBOutlet UITableView *_tableView;
    
    EELocalConnectionManager *_localConnection;
}

- (EELocalConnectionManager*)localConnection;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation EEListOfGamesViewController

#pragma mark - Public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"EEGameTableViewCell" bundle:nil] forCellReuseIdentifier:sGameTableViewCellId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.localConnection startBrowsing];
    [self.localConnection startAdvertiser];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.localConnection startBrowsing];
    [self.localConnection stopAdvertiser];
}

- (void)dealloc {
    [self.localConnection startBrowsing];
    [self.localConnection stopAdvertiser];
}

#pragma mark - Private methods
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

#pragma mark - UITableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localConnection.browsedPeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EEGameTableViewCell *lCell = [tableView dequeueReusableCellWithIdentifier:sGameTableViewCellId forIndexPath:indexPath];

    
    MCPeerID *lPeerId = self.localConnection.browsedPeers[indexPath.row];
    
    lCell.gameName = [lPeerId displayName];
    
    return lCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.localConnection sendInvitationToPeer:self.localConnection.browsedPeers[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView delegate/datasource 
- (void)EELocalConnectionBrowserUpdatePeers {
    [_tableView reloadData];
}

- (void)EELocalConnectionEsteblishedConnection:(EEEsteblishedConnection *)connection {
    [self.localConnection stopAdvertiser];
    
    EEOnlineGameController *lGameController = [[EEOnlineGameController alloc] initWithConnection:[EELocalGameConnection gameConnectionWith:connection]];
    
    dispatch_async(dispatch_get_main_queue(),^{
        EEGameViewController *lGameViewController = [[EEGameViewController alloc] initWithGame:lGameController];
        [self.navigationController pushViewController:lGameViewController animated:YES];
    });
}

- (void)EELocalConnectionNeedPressentAlert:(UIAlertController *)alertController {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    });
}

@end
