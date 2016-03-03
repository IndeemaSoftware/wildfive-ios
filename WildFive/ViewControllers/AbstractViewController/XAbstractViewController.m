//
//  XAbstractViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 10/23/12.
//
//

#import "XAbstractViewController.h"
#import "XCounter.h"

#define BACK_BUTTON_X   10
#define BACK_BUTTON_Y   30
#define BUTTON_WIDTH    110
#define BUTTON_HEIGHT   35

#define BACK_BUTTON_X_iPad   20
#define BACK_BUTTON_Y_iPad   40
#define BUTTON_WIDTH_iPad    230
#define BUTTON_HEIGHT_iPad   70

#define SHOW_HIDE_TIME 0.3f

@interface XAbstractViewController ()
- (UIButton*) backBatton;
- (UIButton*) hintButton;
- (UIButton*) rightButton;
@end

@implementation XAbstractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [mBackButton setTitle:NSLocalizedString(@"Back", @"AbstructVC") forState:UIControlStateNormal];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_FREE_VERSION == YES) {
        //
        if([deviceType() isEqualToString:IPAD]){
            mAdView = [[MPAdView alloc] initWithAdUnitId:PUB_ID_768x90
                                                    size:MOPUB_LEADERBOARD_SIZE];
        }else{
            mAdView = [[MPAdView alloc] initWithAdUnitId:PUB_ID_320x50
                                                    size:MOPUB_BANNER_SIZE];
        }
        
        mAdView.delegate = self;
        [mAdView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
        [self.view addSubview:mAdView];
        [mAdView loadAd];
        //[self adViewDidLoadAd:mAdView];
    }
    
}

- (void) showBackButton {
    [self.view addSubview:[self backBatton]];
    [self.view bringSubviewToFront:[self backBatton]];
    NSLog(@"self.view.subviews %@", self.view.subviews);
    [UIView beginAnimations:@"show_back_button" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHOW_HIDE_TIME];
    if([deviceType() isEqualToString:IPHONE]){
        [[self backBatton] setFrame:CGRectMake(BACK_BUTTON_X, BACK_BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    } else if([deviceType() isEqualToString:IPAD]){
        [[self backBatton] setFrame:CGRectMake(BACK_BUTTON_X_iPad, BACK_BUTTON_Y_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
    }
    
    [UIView commitAnimations];
}

- (void) hideBackButton {
    [UIView beginAnimations:@"hide_back_button" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHOW_HIDE_TIME];
    if([deviceType() isEqualToString:IPHONE]){
        [[self backBatton] setFrame:CGRectMake(BACK_BUTTON_X, -BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    }else if([deviceType() isEqualToString:IPAD]){
        [[self backBatton] setFrame:CGRectMake(BACK_BUTTON_X_iPad, -BUTTON_HEIGHT_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
    }
    
    [UIView commitAnimations];
}

- (void) showRightButton {
    [self.view addSubview:[self rightButton]];
    [self.view bringSubviewToFront:[self rightButton]];
    
    [UIView beginAnimations:@"show_right_button" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHOW_HIDE_TIME];
    
    if([deviceType() isEqualToString:IPHONE]){
        [[self rightButton] setFrame:CGRectMake([self rightButton].frame.origin.x, BACK_BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    }else if([deviceType() isEqualToString:IPAD]){
        [[self rightButton] setFrame:CGRectMake([self rightButton].frame.origin.x, BACK_BUTTON_Y_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
    }
    
    [UIView commitAnimations];
}

- (void) hideRightButton {
    [UIView beginAnimations:@"hide_right_button" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHOW_HIDE_TIME];
    
    if([deviceType() isEqualToString:IPHONE]){
        [[self rightButton] setFrame:CGRectMake([self rightButton].frame.origin.x, -BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    }else if([deviceType() isEqualToString:IPAD]){
        [[self rightButton] setFrame:CGRectMake([self rightButton].frame.origin.x, -BUTTON_HEIGHT_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
    }
    
    [UIView commitAnimations];
}

- (void) setRightButtonTitle:(NSString*)pTitle {
    if (pTitle != nil) {
        [[self rightButton] setTitle:pTitle forState:UIControlStateNormal];
    }
}

- (void) showHintButton {
    [self.view addSubview:[self hintButton]];
    [self.view bringSubviewToFront:[self hintButton]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHOW_HIDE_TIME];
    
    if([deviceType() isEqualToString:IPHONE]){
        [[self hintButton] setCenter:CGPointMake([self hintButton].center.x, BACK_BUTTON_Y + BUTTON_HEIGHT/2)];
    }else if([deviceType() isEqualToString:IPAD]){
        [[self hintButton] setCenter:CGPointMake([self hintButton].center.x, BACK_BUTTON_Y_iPad + BUTTON_HEIGHT_iPad/2)];
    }
    
    [UIView commitAnimations];
}

- (void) hideHintButton {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHOW_HIDE_TIME];
    
    if([deviceType() isEqualToString:IPHONE]){
        [[self hintButton] setCenter:CGPointMake([self hintButton].center.x, -BUTTON_HEIGHT)];
    }else if([deviceType() isEqualToString:IPAD]){
        [[self hintButton] setCenter:CGPointMake([self hintButton].center.x, -BUTTON_HEIGHT_iPad)];
    }
    
    [UIView commitAnimations];

}

- (void) setHintCount:(NSUInteger)pHintCount {
    if (pHintCount == 0) {
        [[self hintButton] setTitle:NSLocalizedString(@"Buy!", @"AbstructV") forState:UIControlStateNormal];
        [[self hintButton] setImage:nil forState:UIControlStateNormal];
    } else {
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
            [[self hintButton] setImage:[UIImage imageNamed:@"bolb_iPad.png"] forState:UIControlStateNormal];
        } else {
            [[self hintButton] setImage:[UIImage imageNamed:@"bolb.png"] forState:UIControlStateNormal];
        }
        [[self hintButton] setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void) addSwipeGesture {
    UISwipeGestureRecognizer *lSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backNavigationButtonPressed:)];
    [lSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:lSwipeGestureRecognizer];
    [lSwipeGestureRecognizer release];
}

- (void) backNavigationButtonPressed:(id)pSender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavigationButtonPressed:(id)pSender {
    
}

- (void) hintNavigationButtonPressed:(id)pSender {
    DLog(@"in Abstract");
    if ([XCounter instance].hintCount == 0){

        [mHintButton setEnabled:NO];
        [self becomeFree:[XPurchasing sharedXPurchasing]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton*) backBatton {
    if (mBackButton == nil) {
        //init back button
        UIFont *lBackButtonFont;
        if([deviceType() isEqualToString:IPHONE]){
            mBackButton = [[UIButton alloc] initWithFrame:CGRectMake(BACK_BUTTON_X, -BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
            lBackButtonFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15.0f];
        }else if([deviceType() isEqualToString:IPAD]){
           mBackButton = [[UIButton alloc] initWithFrame:CGRectMake(BACK_BUTTON_X_iPad, -BUTTON_HEIGHT_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
            lBackButtonFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:30.0f];
        }
        [mBackButton setTitle:NSLocalizedString(@"Back", @"AbstructV") forState:UIControlStateNormal];
        [mBackButton.titleLabel setFont:lBackButtonFont];
        [mBackButton setTitleColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8392f alpha:1.0f] forState:UIControlStateNormal];
        [mBackButton setTitleShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
        [mBackButton.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [mBackButton setBackgroundImage:[UIImage imageNamed:@"left_navigation_button.png"] forState:UIControlStateNormal];
        [mBackButton addTarget:self action:@selector(backNavigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect lLeftCordRect;
        if([deviceType() isEqualToString:IPAD]){
            lLeftCordRect = CGRectMake(15, -20, 20.5f, 26);
        }else{
            lLeftCordRect = CGRectMake(10, -20, 9.5f, 26);
        }
        UIImageView *lLeftCord = [[UIImageView alloc] initWithFrame:lLeftCordRect];
        [lLeftCord setImage:[UIImage imageNamed:@"cord_left.png"]];
        [mBackButton addSubview:lLeftCord];
        [lLeftCord release];
        
        CGRect lRightCordRect;
        if([deviceType() isEqualToString:IPAD]){
            lRightCordRect = CGRectMake(190.0f, -20.0f, 21.5f, 26.0f);
        }else{
            lRightCordRect = CGRectMake(77.0f, -20.0f, 21.5f, 26.0f);
        }
        
        UIImageView *lRightCord = [[UIImageView alloc] initWithFrame:lRightCordRect];
        [lRightCord setImage:[UIImage imageNamed:@"cord_right.png"]];
        [mBackButton addSubview:lRightCord];
        [lRightCord release];
        
        [self.view addSubview:mBackButton];
    }
    return mBackButton;
}

- (UIButton*) hintButton {
    if (mHintButton == nil) {
        //init back button
        UIFont *lBackButtonFont;
        if([deviceType() isEqualToString:IPHONE]){
            mHintButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35.0, -BUTTON_HEIGHT, 70.0, BUTTON_HEIGHT)];
            lBackButtonFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15.0f];
        }else if([deviceType() isEqualToString:IPAD]){
            mHintButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 -  BUTTON_WIDTH_iPad/2, -BUTTON_HEIGHT_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
            lBackButtonFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:30.0f];
        }
        
        if ([XCounter instance].hintCount == 0) {
            [mHintButton setTitle:NSLocalizedString(@"Buy!", @"AbstructV") forState:UIControlStateNormal];
            [mHintButton setImage:nil forState:UIControlStateNormal];
        } else {
            if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
                [mHintButton setImage:[UIImage imageNamed:@"bolb_iPad.png"] forState:UIControlStateNormal];
            } else {
                [mHintButton setImage:[UIImage imageNamed:@"bolb.png"] forState:UIControlStateNormal];
            }
            [mHintButton setTitle:@"" forState:UIControlStateNormal];
        }
        
        [mHintButton.titleLabel setFont:lBackButtonFont];
        [mHintButton setTitleColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8392f alpha:1.0f] forState:UIControlStateNormal];
        [mHintButton setTitleShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
        [mHintButton.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [mHintButton setBackgroundImage:[UIImage imageNamed:@"left_navigation_button.png"] forState:UIControlStateNormal];
        [mHintButton addTarget:self action:@selector(hintNavigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
       // [mHintButton addTarget:self action:@selector(asd) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect lHintLeftCordRect;
        CGRect lHintRightCordRect;
        if([deviceType() isEqualToString:IPAD]){
            lHintLeftCordRect = CGRectMake(20.0f, -20.0f, 20.5f, 26.0f);
            lHintRightCordRect = CGRectMake(190.0f, -20.0f, 21.5f, 26.0f);
        }else{
            lHintLeftCordRect = CGRectMake(10.0f, -20.0f, 9.5f, 26.0f);
            lHintRightCordRect = CGRectMake(40.0f, -20.0f, 21.5f, 26.0f);
        }
        UIImageView *lLeftCord = [[UIImageView alloc] initWithFrame:lHintLeftCordRect];
        [lLeftCord setImage:[UIImage imageNamed:@"cord_left.png"]];
        [mHintButton addSubview:lLeftCord];
        [lLeftCord release];
        
        UIImageView *lRightCord = [[UIImageView alloc] initWithFrame:lHintRightCordRect];
        [lRightCord setImage:[UIImage imageNamed:@"cord_right.png"]];
        [mHintButton addSubview:lRightCord];
        [lRightCord release];
        
        [self.view addSubview:mHintButton];
    }
    return mHintButton;
}

- (UIButton*) rightButton {
    if (mRightButton == nil) {
        //init right button
        CGFloat lRightButtonTextSize;
        if([deviceType() isEqualToString:IPHONE]){
            mRightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - BUTTON_WIDTH - BACK_BUTTON_X, -BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
            lRightButtonTextSize = 15.0f;
        } else if([deviceType() isEqualToString:IPAD]){
            mRightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - BUTTON_WIDTH_iPad - BACK_BUTTON_X_iPad, -BUTTON_HEIGHT_iPad, BUTTON_WIDTH_iPad, BUTTON_HEIGHT_iPad)];
            //mRightButton = [[UIButton alloc] initWithFrame:CGRectMake(300,300,100,100)];
            lRightButtonTextSize = 30.0f;
        }
        [mRightButton setTitle:NSLocalizedString(@"Restart", @"") forState:UIControlStateNormal];
        [mRightButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:lRightButtonTextSize]];
        [mRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mRightButton setTitleColor:[UIColor colorWithRed:0.9725f green:1.0f blue:0.8392f alpha:1.0f] forState:UIControlStateNormal];
        [mRightButton setTitleShadowColor:[UIColor colorWithRed:0.2941f green:0.1764f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
        [mRightButton.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
        [mRightButton setBackgroundImage:[UIImage imageNamed:@"right_navigation_button.png"] forState:UIControlStateNormal];
        [mRightButton addTarget:self action:@selector(rightNavigationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect lRightButtonLeftCordRect;
        CGRect lRightButtonRightCordRect;
        if([deviceType() isEqualToString:IPAD]){
            lRightButtonLeftCordRect = CGRectMake(20, -20, 20.0f, 26);//left
            lRightButtonRightCordRect = CGRectMake(190, -20, 21.5f, 26);//right
        }else{
            lRightButtonLeftCordRect = CGRectMake(10, -20, 9.5f, 26);//left
            lRightButtonRightCordRect = CGRectMake(77, -20, 21.5f, 26);//right
        }
        
        UIImageView *lLeftCord = [[UIImageView alloc] initWithFrame:lRightButtonLeftCordRect];
        [lLeftCord setImage:[UIImage imageNamed:@"cord_left.png"]];
        [mRightButton addSubview:lLeftCord];
        [lLeftCord release];
        
        UIImageView *lRightCord = [[UIImageView alloc] initWithFrame:lRightButtonRightCordRect];
        [lRightCord setImage:[UIImage imageNamed:@"cord_right.png"]];
        [mRightButton addSubview:lRightCord];
        [lRightCord release];
        
        [self.view addSubview:mRightButton];
    }
    return mRightButton;
}

- (void) dealloc {
    XSafeRelease(mBackButton);
    XSafeRelease(mHintButton);
    XSafeRelease(mRightButton);
    XSafeRelease(mAdView);
    [super dealloc];
}
#pragma mark - MPAdViewDelegate methods
- (UIViewController *) viewControllerForPresentingModalView{
    return self;
}

- (void) adViewDidLoadAd:(MPAdView *)view{
    if (IS_FREE_VERSION == YES) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [mAdView setFrame:CGRectMake(0.0f, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)];
        } else {
            [mAdView setFrame:CGRectMake(0.0f, self.view.bounds.size.height - MOPUB_LEADERBOARD_SIZE.height, MOPUB_LEADERBOARD_SIZE.width, MOPUB_LEADERBOARD_SIZE.height)];
        }
    }
}
#pragma mark XPurchasingDelegate
- (void)becomeFree:(XPurchasing *)object {
    if (object.arrayOfProducts.count > 0) {
        UIActionSheet *lActionSheet = [[UIActionSheet alloc] init];
        [lActionSheet setTitle:NSLocalizedString(@"Choose purchase", @"Choose purchase")];
        [lActionSheet setDelegate:self];
        
        for (SKProduct *lProduct in object.arrayOfProducts) {
            DLog(@"products : %@",lProduct.localizedDescription);
            [lActionSheet addButtonWithTitle:lProduct.localizedDescription];
        }
        [lActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        [lActionSheet setCancelButtonIndex:object.arrayOfProducts.count];
        [lActionSheet setTag:4];
        [lActionSheet showInView:self.navigationController.visibleViewController.view];
        
        [lActionSheet release];
    }
    
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"actionSheet %i", buttonIndex);
    if (actionSheet.tag == 4) {
        if (buttonIndex==0) {
            //[[XCounter instance] addHints:100];
            [XCounter instance].hintButtonIndex = 0;
        }else if(buttonIndex==1){
            [XCounter instance].hintButtonIndex = 1;
//            if (IS_FREE_VERSION) {
//                [[XCounter instance] addHints:35];
//            }else{
//                [[XCounter instance] addHints:25];
//            }
        }
        [[XPurchasing sharedXPurchasing] productChosen:buttonIndex];
    }
    [mHintButton setEnabled:YES];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"actionSheetCancel");
}

@end
