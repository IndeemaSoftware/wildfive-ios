//
//  EEBoardViewItem.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoardViewItem.h"

@interface EEBoardViewItem() {
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

- (UIImageView*)imageView;
- (UILabel*)titleLabel;
- (void)updateImageViewImage;
@end

@implementation EEBoardViewItem

#pragma mark - Public methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView setFrame:self.bounds];
    [self.titleLabel setFrame:self.bounds];
}

+ (NSString*)reuseIdentifier {
    return @"EEBoardViewItemId";
}

- (void)setBoardSign:(EEBoardSign)boardSign {
    _boardSign = boardSign;
    
    [self updateImageViewImage];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:_title];
}

#pragma mark - Private methods
- (UIImageView*)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel*)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_titleLabel setMinimumScaleFactor:0.5];
        
//        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)updateImageViewImage {
    NSString *lImageName = @"";
    switch (_boardSign) {
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
    
    
    [self.imageView setImage:[UIImage imageNamed:lImageName]];
}

@end
