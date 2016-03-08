//
//  EEGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameViewController.h"

#import "EEGameController.h"
#import "EEGameCommon.h"
#import "EEPlayer.h"

#import "EEBoardView.h"
#import "EEPlayerView.h"



@interface EEGameViewController() <EEBoardViewDelegate, EEGameControllerDelegate> {
    EEGameController *_gameController;
    IBOutlet EEBoardView *_boardView;
    
    IBOutlet EEPlayerView *_playerView;
    IBOutlet EEPlayerView *_opponentPlayerView;
}

@end

@implementation EEGameViewController

#pragma mark - Public methods
- (instancetype)initWithGame:(EEGameController *)gameController {
    self = [super initWithNibName:@"EEGameViewController" bundle:nil];
    
    if (self) {
        _gameController = gameController;
        [_gameController setDelegate:self];
    }
    
    return self;
}

- (EEGameController *)gameController {
    return _gameController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_boardView setDelegate:self];
    [_boardView reloadData];
    
    [_playerView setPlayerName:_gameController.player.name];
    [_playerView setPlayerType:_gameController.player.type];
    [_playerView setActive:YES];
    
    [_opponentPlayerView setPlayerName:_gameController.opponentPlayer.name];
    [_opponentPlayerView setPlayerType:_gameController.opponentPlayer.type];
}

#pragma mark - Private methods
- (NSUInteger)flowIndex {
    return 2;
}

#pragma mark - EEBoardView delegate
- (EEBoardSize)boardSizeBoardView:(EEBoardView *)boardView {
    return _gameController.boardSize;
}

- (EEBoardSign)boardView:(EEBoardView *)boardView boardSignAtPoint:(EEBoardPoint)point {
    return [_gameController signAtPoint:point];
}

- (BOOL)boardViewPlayerCanPutNewSign:(EEBoardView*)boardView {
    return [_gameController isActionAllowedForPlayer];
}

- (void)boardView:(EEBoardView*)boardView playerSetNewSignAtPoint:(EEBoardPoint)point {
    [_gameController putValuesForPlayerAtPoint:point];
}

#pragma mark - EEGameController delegate methods
- (void)EEGameController:(EEGameController*)gameController updateCellAtPoint:(EEBoardPoint)point {
    [_boardView reloadDataAtPoint:point];
}

- (void)EEGameController:(EEGameController*)gameController activePlayerHasChanged:(EEPlayer*)activePlayer {
    BOOL lIsActivePlayer = (activePlayer.type == gameController.player.type);
    [_playerView setActive:lIsActivePlayer];
    [_opponentPlayerView setActive:!lIsActivePlayer];
}
@end
