//
//  EEPlayerView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEPlayerView.h"

@interface EEPlayerView() {
    UILabel *_nameLabel;
    UIImageView *_signImageView;
}

- (void)initializeView;

- (UILabel*)nameLabel;
- (UIImageView*)signImageView;
- (void)updateSignImage;
@end

@implementation EEPlayerView

#pragma mark - Public mthods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeView];
}

- (void)setPlayerType:(EEPlayerType)playerType {
    _playerType = playerType;
    [self updateSignImage];
}

- (void)setPlayerName:(NSString *)playerName {
    _playerName = [playerName copy];
    [self.nameLabel setText:_playerName];
}

- (void)setActive:(BOOL)active {
    _active = active;
    
    [_nameLabel setHighlighted:_active];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.signImageView setFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.nameLabel setFrame:CGRectMake(20.0f, 0.0f, self.frame.size.width - 20.0f, self.frame.size.height)];
}

#pragma mark - Private mthods
- (void)initializeView {
    [self setBackgroundColor:[UIColor clearColor]];
    
    _playerType = EEPlayerTypeX;
    _playerName = @"";
    
    [self setActive:NO];
    
    [self updateSignImage];
}

- (UILabel*)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setHighlightedTextColor:[UIColor greenColor]];
        
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView*)signImageView {
    if (_signImageView) {
        _signImageView = [[UIImageView alloc] init];
        
        [self addSubview:_signImageView];
    }
    return _signImageView;
}

- (void)updateSignImage {
    if (_playerType == EEPlayerTypeX) {
        [self.signImageView setImage:[UIImage imageNamed:@"boardsign_x"]];
    } else {
        [self.signImageView setImage:[UIImage imageNamed:@"boardsign_o"]];
    }
}
@end
