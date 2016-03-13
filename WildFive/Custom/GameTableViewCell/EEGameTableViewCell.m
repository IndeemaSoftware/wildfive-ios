//
//  EEGameTableViewCell.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameTableViewCell.h"

@interface EEGameTableViewCell() {
    IBOutlet UIImageView *_playerImageView;
    IBOutlet UIImageView *_lockImageView;
    
    IBOutlet UILabel *_gameNameLabel;
}

- (void)updatePlayerImageView;
- (void)updateLockImageView;
- (void)updateGameNameLabel;

@end

@implementation EEGameTableViewCell

#pragma mark - Public methods
- (void)awakeFromNib {
    // Initialization code
    
    [self updatePlayerImageView];
    [self updateLockImageView];
    [self updateGameNameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlayerType:(EEPlayerType)playerType {
    _playerType = playerType;
    [self updatePlayerImageView];
}

- (void)setGameName:(NSString *)gameName {
    _gameName = [gameName copy];
    [self updateGameNameLabel];
}

- (void)setLocked:(BOOL)isLocked {
    _isLocked = isLocked;
    [self updateLockImageView];
}

#pragma mark - Private methods
- (void)updateLockImageView {
    [_lockImageView setHidden:!_isLocked];
}

- (void)updatePlayerImageView {
    NSString *lImageName = @"";
    switch (_playerType) {
        case EEBoardSignO:
            lImageName = @"boardsign_o";
            break;
        case EEBoardSignX:
            lImageName = @"boardsign_x";
            break;
        default:
            lImageName = @"boardsign_none";
            break;
    }
    
    [_playerImageView setImage:[UIImage imageNamed:lImageName]];
}

- (void)updateGameNameLabel {
    [_gameNameLabel setText:_gameName];
}

@end
