//
//  EEAlersViewController.m
//  zipGo
//
//  Created by Volodymyr Shevchyk Jr on 2/9/16.
//  Copyright © 2016 zipGo. All rights reserved.
//

#import "EEAlersViewController.h"
#import "UIImage+Circle.h"

@interface EEAlersViewController ()
- (UIImageView*)backgroundImageView;
@end

@implementation EEAlersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

    [self.backgroundImageView setFrame:self.view.bounds];
    [self.view addSubview:self.backgroundImageView];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIImageView*)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView setAlpha:0.0f];
        [_backgroundImageView setImage:[UIImage gradientCoverImage]];
        [_backgroundImageView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
    }
    return _backgroundImageView;
}

- (void)hideBackground {
    [self.backgroundImageView setAlpha:0.0f];
}

- (void)showBackground {
    [self.backgroundImageView setAlpha:1.0f];
}

@end
