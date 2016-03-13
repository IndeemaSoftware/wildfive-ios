//
//  EEGameViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameViewController.h"

#import "EEGameController.h"
#import "EEPlayer.h"
#import "EEMove.h"

#import "EEBoardView.h"
#import "EEPlayerView.h"


@interface EEGameViewController() <EEBoardViewDelegate, EEGameControllerDelegate> {
    EEGameController *_gameController;
    IBOutlet EEBoardView *_boardView;
    
    IBOutlet EEPlayerView *_playerView;
    IBOutlet EEPlayerView *_opponentPlayerView;
}

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;

- (void)updatePlayerViewsState;

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
    
    [_opponentPlayerView setPlayerName:_gameController.opponentPlayer.name];
    [_opponentPlayerView setPlayerType:_gameController.opponentPlayer.type];
    
    [self updatePlayerViewsState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Private methods
- (NSUInteger)flowIndex {
    return 2;
}

- (IBAction)backButtonPressed:(id)sender {
    [_gameController stopGame];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetButtonPressed:(id)sender {
    [_gameController resetGame];
    
    [_boardView reloadData];
    
    [self updatePlayerViewsState];
}

- (void)updatePlayerViewsState {
    [_playerView setActive:_gameController.isPlayerActive];
    [_opponentPlayerView setActive:!_gameController.isPlayerActive];
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
    if ([_gameController isActionAllowedForPlayer]) {
        EEBoardSign lBoardSign = (_gameController.player.type == EEPlayerTypeX) ? EEBoardSignX : EEBoardSignO;
        
        EEMove *lMove = [EEMove moveWithForPlayer:_gameController.player sign:lBoardSign point:point];
        
        [_gameController makeMove:lMove];
    }
}

#pragma mark - EEGameController delegate methods
- (void)EEGameController:(EEGameController*)gameController updatedItemAtPoint:(EEBoardPoint)point {
    dispatch_async(dispatch_get_main_queue(),^{
         [_boardView reloadDataAtPoint:point];
    });
}

- (void)EEGameController:(EEGameController*)gameController activePlayerHasChanged:(EEPlayer*)activePlayer {
    dispatch_async(dispatch_get_main_queue(),^{
        [self updatePlayerViewsState];
    });
}

- (void)EEGameController:(EEGameController*)gameController gameFinished:(EEFinishResult)finishResult {
    dispatch_async(dispatch_get_main_queue(),^{
        if (!finishResult.hasWinner) {
            [[[UIAlertView alloc] initWithTitle:@"Finish" message:@"Game finished. No winner." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        } else {
            if (_gameController.player.type == finishResult.playerType) {
                [[[UIAlertView alloc] initWithTitle:@"Finish" message:@"You won!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Finish" message:@"You lose!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            }
        }
    });
}

- (void)EEGameController:(EEGameController*)gameController gameInterrupted:(EEInterruptionReason)reason {
    dispatch_async(dispatch_get_main_queue(),^{
        if (reason == EEInterruptionReasonOpponentLeavedGame) {
            [[[UIAlertView alloc] initWithTitle:@"End" message:@"You won!!! Opponent has leaved game." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"End" message:@"Connection lost!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        }
    });
}

@end
