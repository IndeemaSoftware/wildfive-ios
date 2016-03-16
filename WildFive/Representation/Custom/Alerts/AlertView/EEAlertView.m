//
//  EEAlertView.m
//  zipGo
//
//  Created by Volodymyr Shevchyk Jr on 2/9/16.
//  Copyright © 2016 zipGo. All rights reserved.
//

#import "EEAlertView.h"
#import "EEAlertView_hidden.h"
#import "EEAlertViewManager.h"

@interface EEAlertView() {
    UIImageView *_backgroundImageView;
    
    NSTimer *_dismissTimer;
}

- (void)mainInit;
- (UIImageView*)backgroundImageView;

- (void)stopDismissTimer;

@end

@implementation EEAlertView

#pragma mark - Public methods
+ (instancetype)createAlerViewWithNib:(NSString*)nib {
    id lAlerView = nil;
    
    NSArray *lArrayOfViews = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
    if (lArrayOfViews.count > 0) {
        lAlerView = lArrayOfViews.firstObject;
    }
    return lAlerView;
}

+ (instancetype)createAlerView {
    return [self createAlerViewWithNib:NSStringFromClass([self class])];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self mainInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self mainInit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backgroundImageView setFrame:self.bounds];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor  {

}

- (void)show {
     _lastActiveWindow = [UIApplication sharedApplication].keyWindow;
    [[EEAlertViewManager sharedManager] showAlert:self];
}

- (void)dismiss {
    [self stopDismissTimer];
    
    [[EEAlertViewManager sharedManager] dismissAlert:self];
}

- (void)dismissAfter:(NSTimeInterval)afterTime {
    [self stopDismissTimer];
    
    _dismissTimer = [NSTimer scheduledTimerWithTimeInterval:afterTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

#pragma mark - Private methods
- (void)mainInit {
    [super setBackgroundColor:[UIColor clearColor]];
    
    _alertVerticalRatio = 0.5f;
}

- (UIImageView*)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_background"]];
        
        [self insertSubview:_backgroundImageView atIndex:0];
    }
    return _backgroundImageView;
}

- (IBAction)buttonPressed:(id)sender {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(EEAlertView:buttonPressed:)]) {
        UIButton *lButton = sender;
        [_delegate EEAlertView:self buttonPressed:lButton.tag];
    }
}

- (void)stopDismissTimer {
    if (_dismissTimer != nil) {
        if ([_dismissTimer isValid]) {
            [_dismissTimer invalidate];
        }
        _dismissTimer = nil;
    }
}

@end
