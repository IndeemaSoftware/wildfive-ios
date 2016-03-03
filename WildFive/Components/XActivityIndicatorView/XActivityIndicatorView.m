//
//  XActivityIndicatorView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XActivityIndicatorView.h"
#import "XActivityIndicatorDelegate.h"

@interface XActivityIndicatorView()
- (void) cancelButtonPressed;
@end
@implementation XActivityIndicatorView
@synthesize delegate=mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        CGRect lActIndicatorRect;
        if ([deviceType() isEqualToString:IPHONE]) {
            lActIndicatorRect = CGRectMake(0, 0, 20, 20);
        } else if([deviceType() isEqualToString:IPAD]){
            lActIndicatorRect = CGRectMake(0, 0, 50, 50);
        }
        
        mActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:lActIndicatorRect];
        [mActivityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [mActivityIndicator setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        
//        [self setBackgroundColor:[UIColor redColor]];
      //  [self setFrame:CGRectMake(0, 0, 320, 568)];
//        DLog(@"XActivityIndecatorView : %@",NSStringFromCGRect(self.frame));
        [self addSubview:mActivityIndicator];
        mHasMessage = NO;
        mHasCancelButton = NO;
    }
    return self;
}

- (void) cancelButtonPressed {
    if (mDelegate != nil) {
        if ([mDelegate respondsToSelector:@selector(cancelButtonPressedInActivityIndicator)]) {
            [mDelegate cancelButtonPressedInActivityIndicator];
        }
    }
}

- (void) setMessage:(NSString*)pMessage {
    if (pMessage != nil) {
        NSString *lNewMessage = [pMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([lNewMessage length] != 0) {
            if (mMessageLable == nil) {
                [mActivityIndicator setCenter:CGPointMake(mActivityIndicator.center.x, mActivityIndicator.center.y - 15)];
                
                mMessageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, mActivityIndicator.center.y + 20, self.bounds.size.width, 30)];
                CGFloat lMessageLableTextSize;
                if ([deviceType() isEqualToString:IPHONE]) {
                    lMessageLableTextSize = 16.0;
                } else if ([deviceType() isEqualToString:IPAD]){
                    lMessageLableTextSize = 30.0f;
                }
                [mMessageLable setFont:[UIFont fontWithName:FONT_BOLD size:lMessageLableTextSize]];
                [mMessageLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
                [mMessageLable setTextAlignment:UITextAlignmentCenter];
#else
                [mMessageLable setTextAlignment:NSTextAlignmentCenter];
#endif
                [mMessageLable setTextColor:[UIColor whiteColor]];
                [mMessageLable setShadowColor:[UIColor blackColor]];
                [mMessageLable setShadowOffset:CGSizeMake(1, 1)];
                [mMessageLable setBackgroundColor:[UIColor clearColor]];
                
                [self addSubview:mMessageLable];
            }
            [mMessageLable setText:lNewMessage];
        }
    }
}

- (void) setHasCancelButton:(BOOL)pHasButton {
    if (pHasButton) {
        if (mCancelButton == nil) {
            CGRect lRect ;
            CGFloat lCancelButtonMargin;
            CGFloat lCancelButtonTextSize;
            if ([deviceType() isEqualToString:IPHONE]) {
                lRect = CGRectMake(0, 0, 150, 35);
                lCancelButtonTextSize = 16.0;
                lCancelButtonMargin = 90.0f;
            } else if ([deviceType() isEqualToString:IPAD]){
                lRect = CGRectMake(0, 0, 280, 60);
                lCancelButtonTextSize = 30.0f;
                lCancelButtonMargin = 120.0f;
            }
            mCancelButton = [[UIButton alloc] initWithFrame:lRect];
            [mCancelButton setCenter:CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.height - lCancelButtonMargin)];
            [mCancelButton setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
            [mCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [mCancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [mCancelButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
            [[mCancelButton titleLabel] setFont:[UIFont fontWithName:FONT_BOLD size:lCancelButtonTextSize]];
            [[mCancelButton titleLabel] setShadowOffset:CGSizeMake(1, -1)];
            [mCancelButton setTitle:NSLocalizedString(@"Cancel", @"ActivityV")  forState:UIControlStateNormal];
            [mCancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:mCancelButton];
        }
    } else {
        if (mCancelButton != nil) {
            [mCancelButton removeFromSuperview];
            [mCancelButton release];
            mCancelButton = nil;
        }
    }
    mHasCancelButton = pHasButton;
}

-(void) willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self setFrame:CGRectMake(0, 0, newSuperview.bounds.size.width, newSuperview.bounds.size.height)];
        [mActivityIndicator startAnimating];
    } else {
        [mActivityIndicator stopAnimating];
    }
}

- (void) dealloc {
    [mActivityIndicator release];
    XSafeRelease(mMessageLable);
    XSafeRelease(mCancelButton);
    [super dealloc];
}

@end
