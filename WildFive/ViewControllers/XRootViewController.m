//
//  XRootViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/2/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <AudioToolbox/AudioServices.h>

#import "XRootViewController.h"
#import "XNewGameViewController.h"
#import "XAboutViewController.h"
#import "XSettingsViewController.h"
#import "XSettingsViewControllerN.h"
#import "XCommon.h"
#import "XGameCenterManager.h"
#import "XPoster.h"
#import "XSoundEngine.h"
#import "XAnimationDoc.h"
#import "XCounter.h"
#import "XInfoView.h"

@interface XRootViewController(){

}
- (void) authenticationWhenViewLoad;
- (void) hideSplashView;
- (void) showMenu;
//twitter
//private properties
@end

@implementation XRootViewController


#pragma mark - Properties -

#pragma mark - Initialization -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mIsSplashHiden = NO;
      //  DLog(@"Device.model %@",[UIDevice currentDevice].userInterfaceIdiom);//00000000-0000-1000-8000-000C29B58891       

    }
    return self;
}

- (void)dealloc {
    [mMenuView release];
    [mBackgroundImageView release];
    [mSplashScreenImageView release];
    [mButtonNewGame release];
    [mButtonFaceBook release];
    [mButtonTwitter release];
    [mButtonSettings release];
    [mButtonAbout release];
    XSafeRelease(mAnimDocView);
    [super dealloc];
}

#pragma mark - View lifecycle -
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(authenticationWhenViewLoad) withObject:nil afterDelay:1.0f];
    [mButtonNewGame setTitle:NSLocalizedString(@"New Game", @"RootVC") forState:UIControlStateNormal];
    [mButtonFaceBook setTitle:NSLocalizedString(@"Facebook", @"RootVC") forState:UIControlStateNormal];
    [mButtonTwitter setTitle:NSLocalizedString(@"Twitter", @"RootVC") forState:UIControlStateNormal];
    [mButtonInvite setTitle:[NSString stringWithFormat:@"+%i %@", STARS_FOR_INVITE, NSLocalizedString(@"Invite FB", @"RootVC")] forState:UIControlStateNormal];
    [mButtonBuyHints setTitle:NSLocalizedString(@"Buy hints", @"RootVC") forState:UIControlStateNormal];
    [mButtonSettings setTitle:NSLocalizedString(@"Settings", @"RootVC") forState:UIControlStateNormal];
    [mButtonAbout setTitle:NSLocalizedString(@"About", @"RootVC") forState:UIControlStateNormal];

    if (IS_IPHONE_5) {
        [mSplashScreenImageView setImage:[UIImage imageNamed:@"Default-568h.png"]];
    }
    
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval lLastOpenedTime = [lUserDefaults doubleForKey:@"last_posted_time"];
    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lDiffTime = lNowTime - lLastOpenedTime;
    if (lDiffTime > MIN_POST_TIME) {
        [lUserDefaults setDouble:lNowTime forKey:@"last_posted_time"];
        [lUserDefaults synchronize];
    }

    if(RATE_MESSAGE_ONLY_FOR_FREE_VERSION){
        if(IS_FREE_VERSION){
            [self performSelector:@selector(showRateMessage) withObject:nil afterDelay:40.0];
        }
    } else{
        [self performSelector:@selector(showRateMessage) withObject:nil afterDelay:40.0];
    }
    ///
    [[XPurchasing sharedXPurchasing] startPurchasing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (mIsSplashHiden) {
        CGFloat lSizeBackgroundOfffSet = 0.0f;
        CGFloat lSplashOffset = 0.0f;
        if ([deviceType() isEqualToString:IPHONE]) {
            lSizeBackgroundOfffSet = - IPHONE5_DIFF;
            if(IS_IPHONE_5){
                lSizeBackgroundOfffSet = 0.0f;
                lSplashOffset = 0.5*IPHONE5_DIFF-2;
            }
        }
          
       
       mSplashScreenImageView.center = CGPointMake(self.view.frame.size.width / 2, -(self.view.frame.size.height-lSplashOffset) / 2-20);

       mBackgroundImageView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height+lSizeBackgroundOfffSet) / 2);
        
       CGFloat lOffset = 0.0f;
        if([deviceType() isEqualToString:IPHONE]){
            lOffset = IPHONE5_DIFF;
            if (IS_IPHONE_5) {
                lOffset = 0.0f;
            }
        }
       [mMenuView setCenter:CGPointMake(self.view.frame.size.width/2, mMenuView.frame.size.height/2)];
    }
    
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval lLastOpenedTime = [lUserDefaults doubleForKey:@"last_invite_time"];
    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lDiffTime = lNowTime - lLastOpenedTime;
    if (lLastOpenedTime == 0.0) {
        lLastOpenedTime = lNowTime - 2 * MIN_POST_TIME;
    }
    if (lDiffTime > MIN_POST_TIME) {
        [mButtonInvite setEnabled:YES];
    } else {
        [mButtonInvite setEnabled:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(hideSplashView) withObject:nil afterDelay:0.5];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MPAdViewDelegate methods
- (UIViewController *) viewControllerForPresentingModalView{
    return self;
}

# pragma mark - Facebook share score - 
- (IBAction)facebookPressed:(id)pSender{    
   
    XPoster *lFacebookPoster = [XPoster instance];
    [lFacebookPoster postOnFacebookCommon];
    
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval lLastOpenedTime = [lUserDefaults doubleForKey:@"last_posted_time"];
    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lDiffTime = lNowTime - lLastOpenedTime;
    if (lDiffTime > MIN_POST_TIME) {
        [lUserDefaults setDouble:lNowTime forKey:@"last_posted_time"];
        [lUserDefaults synchronize];
        
        [[XCounter instance] addStars:STARS_FOR_POST];
    }
}

# pragma mark - Twitter share - 
- (IBAction)twitter:(id)pSender {
   if ([[UIDevice currentDevice].systemVersion floatValue] <= 5.0) {
        return;
    }
    //  Create an instance of the Tweet Sheet
    TWTweetComposeViewController *tweetSheet = 
    [[TWTweetComposeViewController alloc] init];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any UI updates occur
    // on the main queue
    tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        switch(result) {
            case TWTweetComposeViewControllerResultCancelled:
                //  This means the user cancelled without sending the Tweet
                break;
            case TWTweetComposeViewControllerResultDone:
                //  This means the user hit 'Send'
                break;
        }
        
        
        //  dismiss the Tweet Sheet 
        dispatch_async(dispatch_get_main_queue(), ^{            
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        });
    };
    
    [tweetSheet addImage:[UIImage imageNamed:@"icon_150x150.png"]];
    [tweetSheet setInitialText:@"I play WildFive"];
    [tweetSheet addURL:[NSURL URLWithString:APP_STORE_LINK]];
    
    [self.navigationController presentViewController:tweetSheet animated:YES completion:^{
        
    }];
    [tweetSheet release];
}

#pragma mark - Iterface interaction -

- (IBAction)newGame:(id)pSender {
    XNewGameViewController *lController;
    if ([deviceType() isEqualToString:IPAD]) {
        lController = [[XNewGameViewController alloc] initWithNibName:@"XNewGameViewController_iPad" bundle:nil];
    } else {
        lController = [[XNewGameViewController alloc] initWithNibName:@"XNewGameViewController" bundle:nil];
    }
    [self.navigationController pushViewController:lController animated:YES];
    [lController release];
}

- (IBAction)about:(id)pSender {
    XAboutViewController *lController;
    if ([deviceType() isEqualToString:IPAD]) {
        lController = [[XAboutViewController alloc] initWithNibName:@"XAboutViewController_iPad" bundle:nil];
    } else {
        lController = [[XAboutViewController alloc] initWithNibName:@"XAboutViewController" bundle:nil];
    }

    [self.navigationController pushViewController:lController animated:YES];
    [lController release];
}

- (IBAction)settings:(id)pSender {
    XSettingsViewControllerN *contr ;
    if ([deviceType() isEqualToString:IPAD]) {
        contr = [[XSettingsViewControllerN alloc] initWithNibName:@"XSettingsViewControllerN_iPad" bundle:nil];
    } else {
        contr = [[XSettingsViewControllerN alloc] initWithNibName:@"XSettingsViewControllerN" bundle:nil];
    }
    
    [self.navigationController pushViewController:contr animated:YES];

    XSafeRelease(contr);
    
}

- (IBAction)buyHints:(id)pSender {
    
    [mButtonBuyHints setEnabled:NO];
    [self becomeFree:[XPurchasing sharedXPurchasing]];
}

- (IBAction)inviteFriendsPressed:(id)pSender {
    XPoster *lFacebookPoster = [XPoster instance];
    [lFacebookPoster postInviteOnFacebook];
    
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
    [lUserDefaults setDouble:lNowTime forKey:@"last_invite_time"];
    [lUserDefaults synchronize];
    [mButtonInvite setEnabled:NO];
}

#pragma mark -AnimatedDocumentation
-(void)showAnimatedDoc{
    CGRect lAnimationDocViewRect;
    CGPoint lAnimationDocViewPoint;
    if ([deviceType() isEqualToString:IPHONE]) {
        lAnimationDocViewRect = CGRectMake(10, 480, 300, 350);
        lAnimationDocViewPoint = CGPointMake(160, 250);
    } else if ([deviceType() isEqualToString:IPAD]){
        lAnimationDocViewRect = CGRectMake(10, 1024, 748, 1000);
        lAnimationDocViewPoint = CGPointMake(384, 512);
    }
    mAnimDocView =[[XAnimationDoc alloc] initWithFrame:lAnimationDocViewRect];
    [self.view addSubview:mAnimDocView];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [mAnimDocView setCenter:lAnimationDocViewPoint];
       
    [UIView commitAnimations]; 
}

#pragma mark -GameCenter
- (void) authenticationWhenViewLoad {
    mGameCenterManager = [XGameCenterManager instance];
    if ([XGameCenterManager checkNetStatus]) {
        if(![mGameCenterManager isCheckAuticatePlayer]) {
            
            [mGameCenterManager authenticatePlayer];
        }      
    }
}

- (void) hideSplashView {
    if (mSplashScreenImageView != nil && !mIsSplashHiden) {

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:1.2f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        if(ANIMATION_ON_STARTUP == YES){
            BOOL isSecondaryLoading = [[NSUserDefaults standardUserDefaults] boolForKey:IS_FIRST];
            if (isSecondaryLoading==YES){                                                            
                [UIView setAnimationDidStopSelector:@selector(showMenu)];
                DLog(@"SECOND_LOADING........");
            }else {
                [UIView setAnimationDidStopSelector:@selector(showAnimatedDoc)];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FIRST];
                [self performSelector:@selector(showMenu)withObject:nil afterDelay:14.0f];
                DLog(@"FIRST__LOADING.........");
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            [self performSelector:@selector(showMenu)withObject:nil afterDelay:1.0f];
        }
        //////////////////////////////////////////////////////////////////////////////
        mIsSplashHiden = YES;
        
        CGFloat lSizeBackgroundOfffSet = 0.0f;
        CGFloat lOffset = 0.0f;

        if ([deviceType() isEqualToString:IPHONE]) {
            lSizeBackgroundOfffSet = -88.0f;
            if(IS_IPHONE_5){
                lSizeBackgroundOfffSet = 0.0f;
                lOffset = 0.5*IPHONE5_DIFF-22;
            }
        }else{
            lOffset = 20.0;
        }

        mSplashScreenImageView.center = CGPointMake(self.view.frame.size.width / 2, -(self.view.frame.size.height - lOffset) / 2);
        mBackgroundImageView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height + lSizeBackgroundOfffSet) / 2);
        [mMenuView setCenter:CGPointMake(self.view.frame.size.width/2, mMenuView.frame.size.height/2)];
        [UIView commitAnimations];
    }

}  

- (void) hideDocAnimationView{
    CGRect lAnimationDocViewRect;
    if ([deviceType() isEqualToString:IPHONE]) {
        lAnimationDocViewRect = CGRectMake(10, 480, 300, 350);
    } else if ([deviceType() isEqualToString:IPAD]){
        lAnimationDocViewRect = CGRectMake(10, 1024, 748, 1000);
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [mAnimDocView setFrame:lAnimationDocViewRect];
    [UIView commitAnimations];
}

- (void) showMenu {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_FIRST]==YES){
        [self hideDocAnimationView];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
//    UIWindow *lWindow = [[UIApplication sharedApplication] keyWindow];
    [[XInfoView instance] show];
//    [self.navigationController.view setFrame:CGRectMake(0.0, 20.0, lWindow.frame.size.width, lWindow.frame.size.height - 20.0)];
    
    [UIView commitAnimations];
}

#pragma mark - Game Center - 
- (IBAction)showLeaderBoardButtonClick:(id)sender {
    
//    UINavigationController *lNewNavController = [[UINavigationController alloc] initWithRootViewController:leaderBoardViewController];
//    [leaderBoardViewController release];
//    [self.navigationController presentModalViewController:lNewNavController animated:YES];
//    [lNewNavController release];
    
}
- (IBAction)showAchievementButtonClick:(id)sender {
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"actionSheet %i", buttonIndex);
    if (actionSheet.tag == 5) {
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
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"actionSheetCancel");
}

#pragma mark - UIAlertViewDelegate
-(void)showRateMessage {
    // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowAgain"];
    //[[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"currentDate"];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isSecundaryLoad"]==NO){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowAgain"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSecundaryLoad"];
    }
    
    
    //bool isShowAgain = [[NSUserDefaults standardUserDefaults] valueForKey:@"isShowAgain"];
    NSDate *lYesterdayDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentDate"];

    if((fabs([[NSDate date] timeIntervalSinceDate:lYesterdayDate])>TIME_INTERVAL)||(lYesterdayDate==nil)){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"isShowAgain"]==YES){
            NSString *lMessage = @"If you enjoy using WilFive, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate WildFive"
                                                            message:lMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"No, Thanks"
                                                  otherButtonTitles:@"Rate WildFive",@"Remind me later",nil];
            
            [alert show];
            [alert release];
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"currentDate"];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"buttonindex = %i",buttonIndex);
    
    
    switch (buttonIndex) {
        case 0:
            DLog(@"buttonindex0 : %i No,Thanks",buttonIndex);
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowAgain"];
            break;
        case 1:
            DLog(@"buttonindex1 : %i Rate WildFive",buttonIndex);
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowAgain"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_LINK]];

            break;
        case 2:
            DLog(@"buttonindex2 : %i Remind me later",buttonIndex);
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowAgain"];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark XPurchasingDelegate
- (void)becomeFree:(XPurchasing *)object {
    DLog(@"---becomeFreeMethod");
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
        [lActionSheet setTag:5];
        [lActionSheet showInView:self.navigationController.visibleViewController.view];
        [lActionSheet release];
    }

    [mButtonBuyHints setEnabled:YES];
}

@end
