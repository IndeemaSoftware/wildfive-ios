//
//  XBluetoothGamesTable.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 21/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface XBluetoothGamesTable : UIView <GKSessionDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *mArrayOfGames;
    
    GKSession *mSession;
    
    UITableView *mTableViewGames;
    
    UIButton *mCreateButton;
    UIButton *mConnectButton;
    
    id mDelegate;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSMutableArray *arrayOfGames;
@property (nonatomic, assign) UITableView *tableViewGames;

- (void) initSession;
- (void) releaseSession;

@end
