//
//  XRootViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/2/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <AudioToolbox/AudioServices.h>

#import "EEFlowViewController_hidden.h"

#import "EEMenuViewController.h"

#import "EEGameViewController.h"
#import "EEGameController.h"

#import "AppDelegate.h"

@interface EEMenuViewController() <UIAlertViewDelegate /*EEPurchasingDelegate,*/> {
    IBOutlet UIImageView *_backgroundImageView;
    IBOutlet UIImageView *_splashScreenImageView;
    
    IBOutlet UIView *_menuView;
    IBOutlet UIButton *_onlineGameBtn;
    IBOutlet UIButton *_offlineGameBtn;
    IBOutlet UIButton *_localNetworkGameBtn;
    IBOutlet UIButton *_faceBookBtn;
    IBOutlet UIButton *_twitterBtn;
    IBOutlet UIButton *_inviteBtn;
    IBOutlet UIButton *_buyHintsBtn;
    IBOutlet UIButton *_settingsBtn;
    IBOutlet UIButton *_aboutBtn;

    
    BOOL _isSplashHiden;

}

// buttons selectores
- (IBAction)onlineGameButtonPressed:(id)pSender;
- (IBAction)offlineGameButtonPressed:(id)pSender;
- (IBAction)localNetworkButtonPressed:(id)pSender;
- (IBAction)facebookButtonPressed:(id)pSender;
- (IBAction)twitterButtonPressed:(id)pSender;
- (IBAction)aboutButtonPressed:(id)pSender;
- (IBAction)settingsButtonPressed:(id)pSender;
- (IBAction)buyHintsButtonPressed:(id)pSender;
- (IBAction)inviteFriendsButtonPressed:(id)pSender;

- (void)updateSplashImageView;

- (void)prepareScreenForIntro;
- (void)startIntroAnimation;

- (void)authenticationWhenViewLoad;
- (void)showMenu;
//twitter
//private properties
@end

@implementation EEMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSplashHiden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self performSelector:@selector(authenticationWhenViewLoad) withObject:nil afterDelay:1.0f];
    
    [self updateSplashImageView];
    [self prepareScreenForIntro];
//    [[XPurchasing sharedXPurchasing] startPurchasing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(startIntroAnimation) withObject:nil afterDelay:1.5];
}

- (void)localizeUIElements {
    [_onlineGameBtn setTitle:NSLocalizedString(@"Online", nil) forState:UIControlStateNormal];
    [_offlineGameBtn setTitle:NSLocalizedString(@"Offline", nil) forState:UIControlStateNormal];
    [_localNetworkGameBtn setTitle:NSLocalizedString(@"Local network", nil) forState:UIControlStateNormal];
    [_faceBookBtn setTitle:NSLocalizedString(@"Facebook", @"RootVC") forState:UIControlStateNormal];
    [_twitterBtn setTitle:NSLocalizedString(@"Twitter", @"RootVC") forState:UIControlStateNormal];
    [_inviteBtn setTitle:[NSString stringWithFormat:@"+%i %@", STARS_FOR_INVITE, NSLocalizedString(@"Invite FB", @"RootVC")] forState:UIControlStateNormal];
    [_buyHintsBtn setTitle:NSLocalizedString(@"Buy hints", @"RootVC") forState:UIControlStateNormal];
    [_settingsBtn setTitle:NSLocalizedString(@"Settings", @"RootVC") forState:UIControlStateNormal];
    [_aboutBtn setTitle:NSLocalizedString(@"About", @"RootVC") forState:UIControlStateNormal];
}

- (NSUInteger)flowIndex {
    return 1;
}

#pragma mark - Private methods

- (IBAction)onlineGameButtonPressed:(id)pSender {
    
}

- (IBAction)offlineGameButtonPressed:(id)pSender {
    
}

- (IBAction)localNetworkButtonPressed:(id)pSender {
    EEGameController *lGameController = [[EEGameController alloc] init];
    EEGameViewController *lGameViewController = [[EEGameViewController alloc] initWithGame:lGameController];
    
    [self.navigationController pushViewController:lGameViewController animated:YES];
}

- (IBAction)facebookButtonPressed:(id)pSender{
//    XPoster *lFacebookPoster = [XPoster instance];
//    [lFacebookPoster postOnFacebookCommon];
//    
//    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSTimeInterval lLastOpenedTime = [lUserDefaults doubleForKey:@"last_posted_time"];
//    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval lDiffTime = lNowTime - lLastOpenedTime;
//    if (lDiffTime > MIN_POST_TIME) {
//        [lUserDefaults setDouble:lNowTime forKey:@"last_posted_time"];
//        [lUserDefaults synchronize];
//        
//        [[XCounter instance] addStars:STARS_FOR_POST];
//    }
}

- (IBAction)twitterButtonPressed:(id)pSender {
//    if ([[UIDevice currentDevice].systemVersion floatValue] <= 5.0) {
//        return;
//    }
//    //  Create an instance of the Tweet Sheet
//    TWTweetComposeViewController *tweetSheet =
//    [[TWTweetComposeViewController alloc] init];
//    
//    // Sets the completion handler.  Note that we don't know which thread the
//    // block will be called on, so we need to ensure that any UI updates occur
//    // on the main queue
//    tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result) {
//        switch(result) {
//            case TWTweetComposeViewControllerResultCancelled:
//                //  This means the user cancelled without sending the Tweet
//                break;
//            case TWTweetComposeViewControllerResultDone:
//                //  This means the user hit 'Send'
//                break;
//        }
//        
//        
//        //  dismiss the Tweet Sheet
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:NO completion:^{
//                
//            }];
//        });
//    };
//    
//    [tweetSheet addImage:[UIImage imageNamed:@"icon_150x150.png"]];
//    [tweetSheet setInitialText:@"I play WildFive"];
//    [tweetSheet addURL:[NSURL URLWithString:APP_STORE_LINK]];
//    
//    [self.navigationController presentViewController:tweetSheet animated:YES completion:^{
//        
//    }];
}

- (IBAction)aboutButtonPressed:(id)pSender {
//    XAboutViewController *lController;
//    if ([deviceType() isEqualToString:IPAD]) {
//        lController = [[XAboutViewController alloc] initWithNibName:@"XAboutViewController_iPad" bundle:nil];
//    } else {
//        lController = [[XAboutViewController alloc] initWithNibName:@"XAboutViewController" bundle:nil];
//    }
//    
//    [self.navigationController pushViewController:lController animated:YES];
}

- (IBAction)settingsButtonPressed:(id)pSender {
//    XSettingsViewControllerN *contr ;
//    if ([deviceType() isEqualToString:IPAD]) {
//        contr = [[XSettingsViewControllerN alloc] initWithNibName:@"XSettingsViewControllerN_iPad" bundle:nil];
//    } else {
//        contr = [[XSettingsViewControllerN alloc] initWithNibName:@"XSettingsViewControllerN" bundle:nil];
//    }
//    
//    [self.navigationController pushViewController:contr animated:YES];
//    
//    XSafeRelease(contr);
}

- (IBAction)buyHintsButtonPressed:(id)pSender {
//    [mButtonBuyHints setEnabled:NO];
//    [self becomeFree:[XPurchasing sharedXPurchasing]];
}

- (IBAction)inviteFriendsButtonPressed:(id)pSender {
//    XPoster *lFacebookPoster = [XPoster instance];
//    [lFacebookPoster postInviteOnFacebook];
//    
//    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
//    [lUserDefaults setDouble:lNowTime forKey:@"last_invite_time"];
//    [lUserDefaults synchronize];
//    [mButtonInvite setEnabled:NO];
}

- (void)updateSplashImageView {
    if (IS_IPHONE_5) {
        [_splashScreenImageView setImage:[UIImage imageNamed:@"LaunchImage-700-568h.png"]];
    } else if (IS_IPHONE_6) {
        [_splashScreenImageView setImage:[UIImage imageNamed:@"LaunchImage-800-667h.png"]];
    } else if (IS_IPHONE_6P) {
        [_splashScreenImageView setImage:[UIImage imageNamed:@"LaunchImage-800-Portrait-736h.png"]];
    } else {
        [_splashScreenImageView setImage:[UIImage imageNamed:@"LaunchImage-700.png"]];
    }
}

- (void)prepareScreenForIntro {
    CGRect lScreenBounds = [UIScreen mainScreen].bounds;
    
    [_splashScreenImageView setFrame:lScreenBounds];
    [_backgroundImageView setFrame:CGRectMake(0.0f, lScreenBounds.size.height, lScreenBounds.size.width, lScreenBounds.size.height)];
    [_menuView setFrame:_backgroundImageView.frame];
}

- (void)startIntroAnimation {
    if (!_isSplashHiden) {
        _isSplashHiden = YES;
        
        [UIView animateWithDuration:0.55f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_splashScreenImageView setCenter:CGPointMake(self.view.frame.size.width / 2.0f, -_splashScreenImageView.frame.size.height / 2.0f)];
            [_backgroundImageView setCenter:CGPointMake(self.view.frame.size.width / 2.0f, _backgroundImageView.frame.size.height / 2.0f)];
            [_menuView setCenter:_backgroundImageView.center];
        } completion:nil];
    }
}

#pragma mark -AnimatedDocumentation
- (void)showAnimatedDoc {
//    CGRect lAnimationDocViewRect;
//    CGPoint lAnimationDocViewPoint;
//    if ([deviceType() isEqualToString:IPHONE]) {
//        lAnimationDocViewRect = CGRectMake(10, 480, 300, 350);
//        lAnimationDocViewPoint = CGPointMake(160, 250);
//    } else if ([deviceType() isEqualToString:IPAD]){
//        lAnimationDocViewRect = CGRectMake(10, 1024, 748, 1000);
//        lAnimationDocViewPoint = CGPointMake(384, 512);
//    }
//    mAnimDocView =[[XAnimationDoc alloc] initWithFrame:lAnimationDocViewRect];
//    [self.view addSubview:mAnimDocView];
//   
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:1.0f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    
//    [mAnimDocView setCenter:lAnimationDocViewPoint];
//       
//    [UIView commitAnimations]; 
}

#pragma mark -GameCenter
- (void) authenticationWhenViewLoad {
//    mGameCenterManager = [XGameCenterManager instance];
//    if ([XGameCenterManager checkNetStatus]) {
//        if(![mGameCenterManager isCheckAuticatePlayer]) {
//            
//            [mGameCenterManager authenticatePlayer];
//        }      
//    }
}

- (void) hideDocAnimationView{
//    CGRect lAnimationDocViewRect;
//    if ([deviceType() isEqualToString:IPHONE]) {
//        lAnimationDocViewRect = CGRectMake(10, 480, 300, 350);
//    } else if ([deviceType() isEqualToString:IPAD]){
//        lAnimationDocViewRect = CGRectMake(10, 1024, 748, 1000);
//    }
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:1.0f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [mAnimDocView setFrame:lAnimationDocViewRect];
//    [UIView commitAnimations];
//}
//
//- (void) showMenu {
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_FIRST]==YES){
//        [self hideDocAnimationView];
//    }
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.3f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    
////    UIWindow *lWindow = [[UIApplication sharedApplication] keyWindow];
//    [[XInfoView instance] show];
////    [self.navigationController.view setFrame:CGRectMake(0.0, 20.0, lWindow.frame.size.width, lWindow.frame.size.height - 20.0)];
//    
//    [UIView commitAnimations];
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
//    if (actionSheet.tag == 5) {
//        if (buttonIndex==0) {
//            //[[XCounter instance] addHints:100];
//            [XCounter instance].hintButtonIndex = 0;
//        }else if(buttonIndex==1){
//            [XCounter instance].hintButtonIndex = 1;
////            if (IS_FREE_VERSION) {
////                [[XCounter instance] addHints:35];
////            }else{
////                [[XCounter instance] addHints:25];
////            }
//        }
//        [[XPurchasing sharedXPurchasing] productChosen:buttonIndex];
//    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    NSLog(@"actionSheetCancel");
}

#pragma mark - UIAlertView Delegate
- (void)showRateMessage {
    // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowAgain"];
    //[[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"currentDate"];
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isSecundaryLoad"]==NO){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowAgain"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSecundaryLoad"];
//    }
//    
//    
//    //bool isShowAgain = [[NSUserDefaults standardUserDefaults] valueForKey:@"isShowAgain"];
//    NSDate *lYesterdayDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentDate"];
//
//    if((fabs([[NSDate date] timeIntervalSinceDate:lYesterdayDate])>TIME_INTERVAL)||(lYesterdayDate==nil)){
//        if([[NSUserDefaults standardUserDefaults] boolForKey:@"isShowAgain"]==YES){
//            NSString *lMessage = @"If you enjoy using WilFive, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate WildFive"
//                                                            message:lMessage
//                                                           delegate:self
//                                                  cancelButtonTitle:@"No, Thanks"
//                                                  otherButtonTitles:@"Rate WildFive",@"Remind me later",nil];
//            
//            [alert show];
//            [alert release];
//            
//            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"currentDate"];
//        }
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    DLog(@"buttonindex = %i",buttonIndex);
//    
//    
//    switch (buttonIndex) {
//        case 0:
//            DLog(@"buttonindex0 : %i No,Thanks",buttonIndex);
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowAgain"];
//            break;
//        case 1:
//            DLog(@"buttonindex1 : %i Rate WildFive",buttonIndex);
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowAgain"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_LINK]];
//
//            break;
//        case 2:
//            DLog(@"buttonindex2 : %i Remind me later",buttonIndex);
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowAgain"];
//            break;
//        default:
//            break;
//    }
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark XPurchasingDelegate
//- (void)becomeFree:(XPurchasing *)object {
//    DLog(@"---becomeFreeMethod");
//    if (object.arrayOfProducts.count > 0) {
//        UIActionSheet *lActionSheet = [[UIActionSheet alloc] init];
//        [lActionSheet setTitle:NSLocalizedString(@"Choose purchase", @"Choose purchase")];
//        [lActionSheet setDelegate:self];
//        
//        for (SKProduct *lProduct in object.arrayOfProducts) {
//            DLog(@"products : %@",lProduct.localizedDescription);
//            [lActionSheet addButtonWithTitle:lProduct.localizedDescription];
//        }
//        [lActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
//        [lActionSheet setCancelButtonIndex:object.arrayOfProducts.count];
//        [lActionSheet setTag:5];
//        [lActionSheet showInView:self.navigationController.visibleViewController.view];
//        [lActionSheet release];
//    }
//
//    [mButtonBuyHints setEnabled:YES];
//}

@end
