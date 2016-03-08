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
}

- (UIImageView*)imageView;
- (void)updateImageViewImage;
@end

@implementation EEBoardViewItem

#pragma mark - Public methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView setFrame:self.bounds];
}

+ (NSString*)reuseIdentifier {
    return @"EEBoardViewItemId";
}

- (void)setBoardSign:(EEBoardSign)boardSign {
    _boardSign = boardSign;
    
    [self updateImageViewImage];
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
