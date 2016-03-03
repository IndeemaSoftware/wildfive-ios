//
//  XSelectBluetoothGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "XAppDelegate.h"

@interface XSelectBluetoothGameViewController : XAbstractViewController < GKSessionDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIImageView *mBackgroundImageView;
    IBOutlet UITableView *mTableViewGames;
    IBOutlet UILabel *mNoGamesLabel;
    NSMutableArray *mArrayOfGames;
    GKSession *mSession;
    NSString *mNewGameName;
}
@end
