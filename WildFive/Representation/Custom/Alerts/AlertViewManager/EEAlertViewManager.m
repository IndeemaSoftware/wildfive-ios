//
//  EEAlertViewManager.m
//  zipGo
//
//  Created by Volodymyr Shevchyk Jr on 2/9/16.
//  Copyright © 2016 zipGo. All rights reserved.
//

#import "EEAlertViewManager.h"
#import "EEAlersViewController.h"
#import "EEAlertView_hidden.h"


@interface EEAlertViewManager()
- (void)showAlertView:(EEAlertView*)alertView animated:(BOOL)animated;
- (void)hideAlertView:(EEAlertView*)alertView animated:(BOOL)animated;

- (UIWindow*)alertsWindow;
- (NSMutableArray*)arrayOfAlertViews;
@end

@implementation EEAlertViewManager

+ (EEAlertViewManager*)sharedManager {
    static EEAlertViewManager *sAlertViewManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sAlertViewManager = [[EEAlertViewManager alloc] init];
    });
    return sAlertViewManager;
}

- (void)showAlert:(EEAlertView*)alertView {
    if (alertView != nil) {
        if (!self.alertsWindow.isKeyWindow) {
            [self.alertsWindow makeKeyAndVisible];
        }
        [self.alertsWindow setUserInteractionEnabled:YES];
        
        [self.arrayOfAlertViews addObject:alertView];
        
        if (_currentAlertView != nil) {
            [self hideAlertView:_currentAlertView animated:YES];
            _currentAlertView = nil;
        }
        
        _currentAlertView = alertView;
        [self showAlertView:alertView animated:YES];
    }
}

- (void)dismissAlert:(EEAlertView*)alertView {
    if (alertView != nil) {
        if ([_currentAlertView isEqual:alertView]) {
            [self hideAlertView:alertView animated:YES];
            _currentAlertView = nil;
        }
        
        if ([self.arrayOfAlertViews containsObject:alertView]) {
            [self.arrayOfAlertViews removeObject:alertView];
        }
        
        if (self.arrayOfAlertViews.count == 0) {
            [self.alertsWindow setUserInteractionEnabled:NO];
            
            [UIView animateWithDuration:0.2f delay:0.0f options:((7 << 16) | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                [(EEAlersViewController*)self.alertsWindow.rootViewController hideBackground];
            } completion:^(BOOL finished) {
                if (self.arrayOfAlertViews.count == 0) {
                    [self.alertsWindow resignKeyWindow];
                    [self.alertsWindow setHidden:YES];
                    
                    UIWindow *lLastWindow = alertView.lastActiveWindow;
                    if (lLastWindow != nil) {
                        lLastWindow = [[UIApplication sharedApplication].windows firstObject];
                    }
                    [lLastWindow makeKeyAndVisible];
                }
            }];
        } else {
            _currentAlertView = [self.arrayOfAlertViews lastObject];
            [self showAlertView:_currentAlertView animated:YES];
        }
    }
}

#pragma mark - Private methods
- (void)showAlertView:(EEAlertView*)alertView animated:(BOOL)animated {
    alertView.center = CGPointMake(self.alertsWindow.frame.size.width * 1.5f, self.alertsWindow.frame.size.height * alertView.alertVerticalRatio);
    [self.alertsWindow.rootViewController.view addSubview:alertView];
    [alertView setAlpha:0.2f];
    
    void (^animationBlock)(void) = ^{
        [(EEAlersViewController*)self.alertsWindow.rootViewController showBackground];
        alertView.center = CGPointMake(self.alertsWindow.frame.size.width / 2.0f, alertView.center.y);
        [alertView setAlpha:1.0f];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f delay:0.0f options:((7 << 16) | UIViewAnimationOptionBeginFromCurrentState) animations:animationBlock completion:nil];
    } else {
        animationBlock();
    }
}

- (void)hideAlertView:(EEAlertView*)alertView animated:(BOOL)animated {
    void (^animationBlock)(void) = ^{
        [(EEAlersViewController*)self.alertsWindow.rootViewController showBackground];
        alertView.center = CGPointMake(-self.alertsWindow.frame.size.width / 2.0f, alertView.center.y);
        [alertView setAlpha:0.2f];
    };
    
    void (^complitionBlock)(BOOL finished) = ^(BOOL finished) {
//        alertView.center = CGPointMake(self.alertsWindow.frame.size.width * 1.5f, self.alertsWindow.frame.size.height / 2.0f);
        [alertView removeFromSuperview];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f delay:0.0f options:((7 << 16) | UIViewAnimationOptionBeginFromCurrentState) animations:animationBlock completion:complitionBlock];
    } else {
        animationBlock();
        complitionBlock(YES);
    }
}

- (UIWindow*)alertsWindow {
    if (_alertsWindow == nil) {
        _alertsWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_alertsWindow setWindowLevel:UIWindowLevelAlert];
        [_alertsWindow setScreen:[UIScreen mainScreen]];
        [_alertsWindow setBackgroundColor:[UIColor clearColor]];
        
        [_alertsWindow setRootViewController:[EEAlersViewController new]];
    }
    return _alertsWindow;
}

- (NSMutableArray*)arrayOfAlertViews {
    if (_arrayOfAlertViews == nil) {
        _arrayOfAlertViews = [NSMutableArray new];
    }
    return _arrayOfAlertViews;
}

@end
