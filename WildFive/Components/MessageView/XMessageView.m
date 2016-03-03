//
//  XMessageView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 23/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "XMessageViewDelegate.h"
#import "XMessageViewController.h"

#define INDENT 50
#define BUTTON_HEIGHT 35
#define BUTTON_WIDTH    110
#define INDENT_BETWEEN_BUTTONS 15
#define SCROLL_INDENT 45

#define INDENT_IPAD 50
#define BUTTON_HEIGHT_IPAD 60
#define BUTTON_WIDTH_IPAD    240
#define INDENT_BETWEEN_BUTTONS_IPAD 150
#define SCROLL_INDENT_IPAD 45

@interface XMessageView()
- (void) mainInit;
- (void) cancelButtonPressed:(id)pSender;
- (void) buttonPressed:(id)pSender;
- (void) setVisible:(BOOL)pValue;
- (void) endAnimation:(NSString*)pValue;
- (void) endHiding;
- (void) endShowing;
- (void) transformToHiden;
- (void) transformToShowed;
- (void) findPosition;
- (void) putBackOnPositionMessageView;
- (void) putBackToKeyBoard;
- (void) putBackAfterMoving;

- (void) hideKeyBoard;
@end

@implementation XMessageView
@synthesize position=mPosition;
@synthesize isVisible=mIsVisble;
@synthesize delegate=mDelegate;

#pragma mark - Init -
- (id)initWithTitle:(NSString *)pTitle message:(NSString *)pMessage delegate:(id)pDelegate cancelButtonTitle:(NSString *)pCancelButtonTitle {
    self = [super init];
    if (self) {
        [self mainInit];
        mDelegate = pDelegate;
        [self setTitle:pTitle];
        [self setMessage:pMessage];
        [self setTitleForCancelButton:pCancelButtonTitle];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self mainInit];
    }
    return self;
}

- (void) mainInit {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setMultipleTouchEnabled:NO];
    [self setVisible:NO];
    mIsVisble = NO;
    mCanMove = NO;
    mIsEditing = NO;
    mPosition = XMessageViewPositionCenter;
    
    mMessageController = [XMessageViewController instance];
    
    mWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect lFrame = [[UIScreen mainScreen] bounds];
    [super setFrame:lFrame];
    if (mVisableView != nil) {
        [mVisableView removeFromSuperview];
        [mVisableView release];
        mVisableView = nil;
    }
    CGRect lRect;
    if ([deviceType() isEqualToString:IPHONE]) {
        lRect = CGRectMake(INDENT, INDENT, lFrame.size.width - INDENT, 100);
    } else if([deviceType() isEqualToString:IPAD]){
        lRect = CGRectMake(INDENT_IPAD, INDENT_IPAD, lFrame.size.width - INDENT_IPAD, 250);
    }
    mVisableView = [[UIView alloc] initWithFrame:lRect];
    [mVisableView setBackgroundColor:[UIColor clearColor]];
    [mVisableView setMultipleTouchEnabled:NO];
    [mVisableView.layer setShadowColor:[UIColor blackColor].CGColor];
    [mVisableView.layer setShadowOpacity:1.0];
    [mVisableView.layer setShadowRadius:30.0];
    
    CGRect lLegsRect;
    if ([deviceType() isEqualToString:IPHONE]) {
        lLegsRect = CGRectMake(mVisableView.frame.size.width - 48, 15, 48, 45);
    } else if ([deviceType() isEqualToString:IPAD]){
        lLegsRect = CGRectMake(mVisableView.frame.size.width - 48, 20, 48, 100);
    }
    UIImageView *lLegs = [[UIImageView alloc] initWithFrame:lLegsRect];
    [lLegs setImage:[UIImage imageNamed:@"message_view_legs"]];
    [mVisableView addSubview:lLegs];
    
    CGRect lBackgroundRect;
    if ([deviceType() isEqualToString:IPHONE]) {
        lBackgroundRect = CGRectMake(lLegs.frame.origin.x - 210, 0, 217, 60);
    }
    else if([deviceType() isEqualToString:IPAD]){
        lBackgroundRect = CGRectMake(lLegs.frame.origin.x - 650, 0, 660, 150);
    }
    UIImageView *lBackground = [[UIImageView alloc] initWithFrame:lBackgroundRect];

    if([deviceType() isEqualToString:IPAD]){
        [lBackground setImage:[UIImage imageNamed:@"message_view_backgound@2x~ipad.png"]];
    }else{
        [lBackground setImage:[UIImage imageNamed:@"message_view_background.png"]];
    }
    
    [mVisableView addSubview:lBackground];
    
    
    //cancel button
    CGRect lCancelButtonRect;
    CGFloat lCancelButtonTextSize;
    if ([deviceType() isEqualToString:IPHONE]){
        lCancelButtonRect = CGRectMake(5, lBackground.frame.size.height + 10, BUTTON_WIDTH, BUTTON_HEIGHT);
        lCancelButtonTextSize = 15.0f;
    } else if ([deviceType() isEqualToString:IPAD]){
        lCancelButtonRect = CGRectMake(30, lBackground.frame.size.height + 10, BUTTON_WIDTH_IPAD, BUTTON_HEIGHT_IPAD);
        lCancelButtonTextSize = 30.0f;
    }
    mCancelButton = [[UIButton alloc] initWithFrame:lCancelButtonRect];
    [mCancelButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [mCancelButton setTitle:NSLocalizedString(@"Cancel", @"MessageV") forState:UIControlStateNormal];
    [mCancelButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:lCancelButtonTextSize]];
    [mCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mCancelButton setTitleColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8392f alpha:1.0f] forState:UIControlStateNormal];
    [mCancelButton setTitleShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
    [mCancelButton.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [mCancelButton setBackgroundImage:[UIImage imageNamed:@"right_navigation_button.png"] forState:UIControlStateNormal];
    [mCancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    DLog(@"mCancelButton : %@",NSStringFromCGRect(mCancelButton.frame));
    
    CGRect lCancelButtonLeftCordRect;
    CGRect lCancelButtonRightCordRect;
    if ([deviceType() isEqualToString:IPAD]) {
        lCancelButtonLeftCordRect = CGRectMake(20, -20, 20.0f, 26);
        lCancelButtonRightCordRect = CGRectMake(195, -20, 21.5f, 26);
    }else{
        lCancelButtonLeftCordRect = CGRectMake(10, -20, 9.5f, 26);
        lCancelButtonRightCordRect = CGRectMake(70, -20, 21.5f, 26);
    }
    
    UIImageView *lLeftCord = [[UIImageView alloc] initWithFrame:lCancelButtonLeftCordRect];
    [lLeftCord setImage:[UIImage imageNamed:@"cord_left.png"]];
    [mCancelButton addSubview:lLeftCord];
    [lLeftCord release];
    
    UIImageView *lRightCord = [[UIImageView alloc] initWithFrame:lCancelButtonRightCordRect];
    [lRightCord setImage:[UIImage imageNamed:@"cord_right.png"]];
    [mCancelButton addSubview:lRightCord];
    [lRightCord release];
    
    [mVisableView insertSubview:mCancelButton belowSubview:lBackground];
    
    [super addSubview:mVisableView];
    [self transformToHiden];
    [mWindow addSubview:self];
    
    [lLegs release];
    [lBackground release];
}

#pragma mark - Private methods -
- (void) cancelButtonPressed:(id)pSender {
    [self hideKeyBoard];
    if (mDelegate) {
        if ([mDelegate respondsToSelector:@selector(messageViewCancelButtonPressed:)]) {
            [mDelegate messageViewCancelButtonPressed:[[self retain] autorelease]];
        } else {
            DLog(@"Not found selector");
        }
    } else {
        DLog(@"Not found delegate");
    }
    [self hide];
}

- (void) buttonPressed:(id)pSender {
    [self hideKeyBoard];
    UIButton *lButton = (UIButton*)pSender;
   
    if (mDelegate) {
        if ([mDelegate respondsToSelector:@selector(messageView:clickedButtonAtIndex:)]) {
            [mDelegate messageView:[[self retain] autorelease] clickedButtonAtIndex:lButton.tag];
        } else {
            DLog(@"Not found selector");
        }
    } else {
        DLog(@"Not found delegate");
    }
    [self hide];
}

- (void) setVisible:(BOOL)pValue {
    [super setHidden:!pValue];
}

- (void) endAnimation:(NSString*)pValue {
    if ([pValue isEqualToString:@"show"]) {
        [self endShowing];
    } else if ([pValue isEqualToString:@"hide"]) {
        [mMessageController hidedMessageView:self];
        [self endHiding];
    }
}

- (void) endHiding {
    [self setVisible:NO];
    mIsVisble = NO;
    if ([self superview] != nil) {
        [self removeFromSuperview];
    }
}

- (void) endShowing {
    mIsVisble = YES;
}

- (void) transformToHiden {
    CATransform3D lT = mVisableView.layer.transform;
    lT.m34 = 1 / mVisableView.frame.size.width;
    mVisableView.layer.transform = lT;
    mVisableView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    mVisableView.layer.transform = CATransform3DMakeRotation(M_PI_2 + 1, 0.0, 1.0, 0.0);
}

- (void) transformToShowed {
    CATransform3D lT = mVisableView.layer.transform;
    lT.m34 = 1 / -mVisableView.frame.size.width;
    mVisableView.layer.transform = lT;
    mVisableView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    mVisableView.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0);
}


- (void) findPosition {
    if (mPosition == XMessageViewPositionTop) {
        [mVisableView setCenter:CGPointMake(mWindow.frame.size.width, mVisableView.frame.size.height / 2 + 5 + SCROLL_INDENT)];
    } else if (mPosition == XMessageViewPositionCenter){
        [mVisableView setCenter:CGPointMake(mWindow.frame.size.width, mWindow.frame.size.height / 2)];
    } else if (mPosition == XMessageViewPositionBottom) {
        [mVisableView setCenter:CGPointMake(mWindow.frame.size.width, mWindow.frame.size.height - mVisableView.frame.size.height / 2 - SCROLL_INDENT_IPAD - 5)];
    }
}

- (void) putBackOnPositionMessageView {
    if (mIsEditing) {
        [UIView beginAnimations:@"hiding_keyboard" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self findPosition];
        [UIView commitAnimations];
    }
    mIsEditing = NO;
}

- (void) putBackToKeyBoard {
    mCanMove = NO;
    CGFloat lBottomY = mWindow.frame.size.height - CGRectGetMaxY(mVisableView.frame);
    if (lBottomY < 216) {
        [UIView beginAnimations:@"show_keyboard" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        mVisableView.center = CGPointMake(mVisableView.center.x, mVisableView.center.y - (216 - lBottomY));
        [UIView commitAnimations];
    }
}

- (void) putBackAfterMoving {
    [UIView beginAnimations:@"putBackAfterMoving" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self findPosition];
    [UIView commitAnimations];
}

- (void) hideKeyBoard {
    if (mTextField != nil) {
        [mTextField resignFirstResponder];
    }
}

#pragma mark - Public methods -
- (void) show {
    [mMessageController showMessageView:self];
}

- (void) hide {
    if (mIsVisble) {
        [UIView beginAnimations:@"hide" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endAnimation:)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self transformToHiden];
        [UIView commitAnimations];
    }
}

- (void) starShowing {
    if (mWindow == nil) {
        return;
    }
    if (!mIsVisble) {
        if ([self superview] == nil) {
            [mWindow addSubview:self];
        }
        [super setFrame:mWindow.bounds];
        [self findPosition];
        
        [self setVisible:YES];
        
        [UIView beginAnimations:@"show" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endAnimation:)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self transformToShowed];
        [UIView commitAnimations];
    }
}

- (void) setTitle:(NSString*)pTitle {
    if (pTitle != nil) {
        if (mTitleLable == nil) {
            CGRect lTitleRect;
            if ([deviceType() isEqualToString:IPHONE]){
                lTitleRect = CGRectMake(30, 2, mVisableView.frame.size.width - INDENT, 20);
            } else if ([deviceType() isEqualToString:IPAD]){
                lTitleRect = CGRectMake(80, 12, mVisableView.frame.size.width - INDENT_IPAD, 30);
            }
            mTitleLable = [[UILabel alloc] initWithFrame:lTitleRect];
            [mTitleLable setTextAlignment:NSTextAlignmentCenter];
            [mTitleLable setBackgroundColor:[UIColor clearColor]];
            [mTitleLable setTextColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8992f alpha:1.0f]];
            [mTitleLable setShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f]];
            [mTitleLable setShadowOffset:CGSizeMake(0.0f, -1.0f)];
            if ([deviceType() isEqualToString:IPHONE]) {
                [mTitleLable setFont:[UIFont fontWithName:FONT_BOLD size:14.0f]];
            } else if ([deviceType() isEqualToString:IPAD]) {
                [mTitleLable setFont:[UIFont fontWithName:FONT_BOLD size:30.0f]];
            }
            
            [mVisableView addSubview:mTitleLable];
        }
        [mTitleLable setText:pTitle];
    }
}

- (void) setMessage:(NSString*)pMessage {
    if (pMessage != nil) {
        if (mMessageLable == nil) {
            CGRect lMessageRect;
            CGFloat lMessageLableTextSize;
            if ([deviceType() isEqualToString:IPHONE]){
                lMessageRect = CGRectMake(30, 17, mVisableView.frame.size.width - INDENT, 40);
                lMessageLableTextSize = 14.0f;
            }else  if ([deviceType() isEqualToString:IPAD]){
                lMessageRect = CGRectMake(30, 42, mVisableView.frame.size.width - INDENT_IPAD+30, 80);
                lMessageLableTextSize = 30.0f;
            }
            mMessageLable = [[UILabel alloc] initWithFrame:lMessageRect];
            [mMessageLable setTextAlignment:NSTextAlignmentCenter];
            [mMessageLable setBackgroundColor:[UIColor clearColor]];
            [mMessageLable setTextColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8992f alpha:1.0f]];
            [mMessageLable setShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f]];
            [mMessageLable setShadowOffset:CGSizeMake(0.0f, -1.0f)];
            [mMessageLable setFont:[UIFont fontWithName:FONT size:lMessageLableTextSize]];
            [mMessageLable setNumberOfLines:2];
            [mMessageLable setLineBreakMode:NSLineBreakByWordWrapping];
            [mVisableView addSubview:mMessageLable];
        }
        [mMessageLable setText:pMessage];
    }
}

- (void) setTitleForCancelButton:(NSString*)pTitle {
    if (pTitle != nil) {
        [mCancelButton setTitle:pTitle forState:UIControlStateNormal];
    }
}

- (void) setTitle:(NSString*)pTitle forButtonAtIndex:(NSUInteger)pIndex {
    if (mArrayOfButtons) {
        if (pIndex < [mArrayOfButtons count]) {
            UIButton *lButton = [mArrayOfButtons objectAtIndex:pIndex];
            [lButton setTitle:pTitle forState:UIControlStateNormal];
        }
    }
}

- (void) addButtonWithTitle:(NSString*)pButtonTitle {
    if (mArrayOfButtons == nil) {
        mArrayOfButtons = [[NSMutableArray alloc] init];
    }
    NSUInteger lButtonIndex = [mArrayOfButtons count];
    CGRect lNewButtonRect;
    CGFloat lNewButtonTextSize;
    if ([deviceType() isEqualToString:IPHONE]){
        lNewButtonRect = CGRectMake(mCancelButton.frame.origin.x + BUTTON_WIDTH + INDENT_BETWEEN_BUTTONS + lButtonIndex * (BUTTON_WIDTH + INDENT_BETWEEN_BUTTONS), mCancelButton.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
        lNewButtonTextSize = 15.0f;
    }else if ([deviceType() isEqualToString:IPAD]){
        lNewButtonRect = CGRectMake(mCancelButton.frame.origin.x + BUTTON_WIDTH_IPAD + INDENT_BETWEEN_BUTTONS_IPAD + lButtonIndex * (BUTTON_WIDTH_IPAD + INDENT_BETWEEN_BUTTONS_IPAD), mCancelButton.frame.origin.y, BUTTON_WIDTH_IPAD, BUTTON_HEIGHT_IPAD);
        lNewButtonTextSize = 30.0f;
    }
    UIButton *lNewButton = [[UIButton alloc] initWithFrame:lNewButtonRect];
    
    [lNewButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
    [lNewButton setTag:lButtonIndex];
    [lNewButton setBackgroundColor:[UIColor clearColor]];
    [lNewButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [lNewButton setTitle:pButtonTitle forState:UIControlStateNormal];
    [lNewButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:lNewButtonTextSize]];
    [lNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lNewButton setTitleColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8392f alpha:1.0f] forState:UIControlStateNormal];
    [lNewButton setTitleShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
    [lNewButton.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    [lNewButton setBackgroundImage:[UIImage imageNamed:@"right_navigation_button.png"] forState:UIControlStateNormal];
    [lNewButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect lNewButtonLeftCordRect;
    CGRect lNewButtonRightCordRect;
    if ([deviceType() isEqualToString:IPAD]) {
        lNewButtonLeftCordRect = CGRectMake(20, -20, 20.0f, 26);
        lNewButtonRightCordRect = CGRectMake(195, -20, 21.5f, 26);
    }else{
        lNewButtonLeftCordRect = CGRectMake(10, -20, 9.5f, 26);
        lNewButtonRightCordRect = CGRectMake(70, -20, 21.5f, 26);
    }
    
    UIImageView *lLeftCord = [[UIImageView alloc] initWithFrame:lNewButtonLeftCordRect];
    [lLeftCord setImage:[UIImage imageNamed:@"cord_left.png"]];
    [lNewButton addSubview:lLeftCord];
    [lLeftCord release];
    
    UIImageView *lRightCord = [[UIImageView alloc] initWithFrame:lNewButtonRightCordRect];
    [lRightCord setImage:[UIImage imageNamed:@"cord_right.png"]];
    [lNewButton addSubview:lRightCord];
    [lRightCord release];
    
    [mVisableView insertSubview:lNewButton belowSubview:mCancelButton];
    [mArrayOfButtons addObject:lNewButton];
    [lNewButton release];
}

- (void) addTextFieldWithPlaceHolder:(NSString*)pText {
    if (mTextField == nil) {
        CGRect lTextFieldRect;
        if ([deviceType() isEqualToString:IPHONE]) {
            lTextFieldRect = CGRectMake(30, mVisableView.frame.size.height - BUTTON_HEIGHT - 40, mVisableView.frame.size.width - INDENT, 25);
        } else if([deviceType() isEqualToString:IPAD]){
            lTextFieldRect = CGRectMake(70, mVisableView.frame.size.height - BUTTON_HEIGHT_IPAD - 130, mVisableView.frame.size.width - INDENT_IPAD, 50);
        }
        mTextField = [[UITextField alloc] initWithFrame:lTextFieldRect];
        [mTextField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
        [mTextField setBorderStyle:UITextBorderStyleRoundedRect];
//      [mTextField setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.3]];
        [mTextField setTextColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f]];
        
        if ([deviceType() isEqualToString:IPHONE]) {
            [mTextField setFont:[UIFont fontWithName:FONT size:14]];
        } else if ([deviceType() isEqualToString:IPAD]) {
            [mTextField setFont:[UIFont fontWithName:FONT size:35]];
        }
        [mTextField setDelegate:self];
        [mTextField setReturnKeyType:UIReturnKeyDone];
        [mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        if (pText != nil) {
            [mTextField setPlaceholder:pText];
        } else {
            [mTextField setPlaceholder:NSLocalizedString(@"insert text", @"MessageV") ];
        }
        
        if (mMessageLable != nil) {
            [mMessageLable setCenter:CGPointMake(mMessageLable.center.x, mTextField.center.y - 20)];
        }
        
        [mVisableView addSubview:mTextField];
    }
}

#pragma mark - Reloaded methods -
- (void) addSubview:(UIView *)view {
    [mVisableView addSubview:view];
}

- (void)setHidden:(BOOL)hidden {
    
}

- (void) setFrame:(CGRect)frame {
    [mVisableView setFrame:frame];
}

- (CGRect) frame {
    return mVisableView.frame;
}

#pragma mark - Text Field Delegate's methods -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    mIsEditing = YES;
    [self putBackToKeyBoard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    DLog(@"end edit: %@", textField.text);
    if (mDelegate) {
        if ([mDelegate respondsToSelector:@selector(messageView:endEditingTextField:)]) {
            [mDelegate messageView:[[self retain] autorelease] endEditingTextField:textField.text];
        } else {
            DLog(@"Not found selector");
        }
    } else {
        DLog(@"Not found delegate");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self putBackOnPositionMessageView];
    return YES;
}

#pragma mark - Events handling -
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyBoard];
    [self putBackOnPositionMessageView];
    
    if (mVisableView != nil) {
        if (!mCanMove) {
            UITouch *lTouch = [[event allTouches] anyObject];
            mTopIndent = CGRectGetMinY(mVisableView.frame) - SCROLL_INDENT;
            mBottomIndent = mWindow.frame.size.height - CGRectGetMaxY(mVisableView.frame) - SCROLL_INDENT;
            
            CGPoint lLocation = [lTouch locationInView:self];
            if (CGRectContainsPoint(mVisableView.frame, lLocation)) {
                mCanMove = YES;
            }
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mCanMove) {
        UITouch *lTouch = [[event allTouches] anyObject];
        if (mVisableView != nil) {
            CGPoint lLocation = [lTouch locationInView:self];
            CGPoint lPreviousLocation = [lTouch previousLocationInView:self];
            CGFloat lTransition = lLocation.y - lPreviousLocation.y;
            CGFloat lAdder = 0.0;
            
            if (lTransition > 0) {
                lAdder = (mWindow.bounds.size.height - CGRectGetMaxY(mVisableView.frame) - SCROLL_INDENT) / mBottomIndent;
            } else {
                lAdder = (CGRectGetMinY(mVisableView.frame) - SCROLL_INDENT) / mTopIndent;
            }
            
            if (lAdder > 0) {
                if (lAdder >  1) {
                    lAdder = 1;
                }
                CGFloat lNewY = mVisableView.center.y + lAdder * lTransition;
                [mVisableView setCenter:CGPointMake(mVisableView.center.x, lNewY)];
            }
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {   
    if (mCanMove) {
        [self putBackAfterMoving];
    }
    mCanMove = NO;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.



#pragma mark - Dealloc -
- (void) dealloc {
    DLog(@"message view dealloc");
    XSafeRelease(mTextField);
    XSafeRelease(mVisableView);
    XSafeRelease(mCancelButton);
    XSafeRelease(mArrayOfButtons);
    XSafeRelease(mTitleLable);
    XSafeRelease(mMessageLable);
    [super dealloc];
}

@end
