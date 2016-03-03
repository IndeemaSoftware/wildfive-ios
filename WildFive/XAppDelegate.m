//
//  XAppDelegate.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/2/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//
#import <GameKit/GameKit.h>

#import "XAppDelegate.h"
#import "XRootViewController.h"
#import "XConfiguration.h"
#import "XSoundEngine.h"
#import "XMessageViewController.h"
#import "XPoster.h"
#import "FacebookManager.h"
#import "XCounter.h"

NSString *const FBSessionStateChangedNotification = @"optigra.org.Login:FBSessionStateChangedNotification";

@interface XAppDelegate()
- (void) firstStart;
- (void) makeLocalNotification;
- (void) addBonus;
@end

@implementation XAppDelegate

@synthesize navigationController=mNavigationController;
@synthesize window = _window;
@synthesize currentReachabilityNet=mHostReach;
@synthesize netStatus = mNetStatus;
@synthesize mIsOnlineGame;
@synthesize rootViewController = mRootViewController;

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
     return [[FacebookManager instance] handleUrlForSession:url];
}

- (void)dealloc {
    [XPoster release];
    [XMessageViewController release];
    [_window release];
    [ mNavigationController release ];
    [super dealloc];
}

- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    [RevMobAds startSessionWithAppID:@"51c892a433bcc0386f000045"];
    
    [NSTimer scheduledTimerWithTimeInterval:300.0 target:[[UIApplication sharedApplication] delegate] selector:@selector(showAdd) userInfo:nil repeats:YES];
    
    mAlertRevMob = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Adds!", nil) message:NSLocalizedString(@"Don't want to see this boring adds anymore?", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove Adds!", nil] autorelease];
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:mAlertRevMob selector:@selector(show) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:315.0 target:mAlertRevMob selector:@selector(show) userInfo:nil repeats:YES];

    
    if (launchOptions != nil) {
        UILocalNotification *lNotification = [launchOptions objectForKey:
                                              UIApplicationLaunchOptionsLocalNotificationKey];
		
		if (lNotification) {
            [self makeLocalNotification];
		}
    }
    
    if( [deviceType() isEqualToString:IPHONE]){

        mRootViewController = [[XRootViewController alloc] initWithNibName:@"XRootViewController" bundle:nil];

    } else if([deviceType() isEqualToString:IPAD]){
        mRootViewController = [[XRootViewController alloc] initWithNibName:@"XRootViewController_iPad" bundle:nil];
    }
    mNavigationController = [[UINavigationController alloc] initWithRootViewController:mRootViewController];
    mNavigationController.delegate = self;
    [mNavigationController setNavigationBarHidden:YES];
//setting background image for navigation bar (only for iOS 5.0 and higher)
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
//    }
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor clearColor];
    [self.window addSubview:mNavigationController.view];
    
    [self.window makeKeyAndVisible];
    //*********DEFAULT PROPERTIES********//
    if ([[NSUserDefaults standardUserDefaults] objectForKey:S_FIRST_START_KEY] == nil) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:S_FIRST_START_KEY];
        [[XConfiguration sharedConfiguration] setDefaultSettings];
        
    }
    if ([[XConfiguration sharedConfiguration] soundeEnable]) {
        
        [[XSoundEngine sharedEngine] playSound:XSoundBackground];
    }
    
  
    //Notification that internet changed status (On/Off)  
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: K_REACHABILITY_CHANGE_NOTIFICATION object: nil];
	mHostReach = [[XReachabilityNet reachabilityWithHostName:@"www.apple.com"] retain];
	[mHostReach startNotifier];
	[self updateInterfaceWithReachability: mHostReach];
    
    [self firstStart];

    NSString *upgradekey = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".upgrade"];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:upgradekey]) {
        // revmob
        [RevMobAds startSessionWithAppID:@"51c892a433bcc0386f000045"];
    }
    
    return YES;
}
- (void) updateInterfaceWithReachability:(XReachabilityNet*)pCurReach {
    mNetStatus = [pCurReach currentReachabilityStatus];
}
- (void) reachabilityChanged:(NSNotification*)pNote {
	XReachabilityNet* lCurReach = [pNote object];
	NSParameterAssert([lCurReach isKindOfClass: [XReachabilityNet class]]);
	[self updateInterfaceWithReachability: lCurReach];
    
    [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
        // Insert application-specific code here to clean up any games in progress.
        DLog(@"inviteHandler");
        if (acceptedInvite){
            GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite] autorelease];
         //   [mRootViewController presentModalViewController:mmvc animated:YES ];
            [mRootViewController presentViewController:mmvc animated:YES completion:nil];
        }
        else if (playersToInvite)
        {
            GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
            request.minPlayers = 2;
            request.maxPlayers = 4;
            request.playersToInvite = playersToInvite;
            
            GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
            //[mRootViewController presentModalViewController:mmvc animated:YES];
            [mRootViewController presentViewController:mmvc animated:YES completion:nil];
        }
    };
}

- (void) applicationWillResignActive:(UIApplication*)application {
    DLog(@"applicationWillResignActive");
    [[NSUserDefaults standardUserDefaults] setInteger:[XCounter instance].hintCount forKey:HINT_COUNT];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void) applicationDidEnterBackground:(UIApplication*)application {
    DLog(@"applicationDidEnterBackground");
    
    [[XCounter instance] save];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {    
    DLog(@"applicationDidBecomeActive");
    
    [self showAdd];
    
    application.applicationIconBadgeNumber = 0;
    [XCounter instance];
    [FBSession.activeSession handleDidBecomeActive];
 
    [self performSelector:@selector(addBonus) withObject:nil afterDelay:1.5];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    DLog(@"applicationWillTerminate");
    [[NSUserDefaults standardUserDefaults] setInteger:[XCounter instance].hintCount forKey:HINT_COUNT];
    [mHostReach stopNotifier];
    [FBSession.activeSession close];
    [[XCounter instance] save];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self makeLocalNotification];
}

- (void) firstStart {
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL lIsFirst = [lUserDefaults boolForKey:@"first_star"];

    if (!lIsFirst) {
        [self makeLocalNotification];
        [lUserDefaults setBool:YES forKey:@"first_star"];
    }
}

- (void) makeLocalNotification {
    UILocalNotification *lLocalNotification = [[UILocalNotification alloc] init];
    
    NSTimeInterval lTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lOffset = NOTOFICATION_TIME + arc4random() % NOTOFICATION_TIME;
    lTimeInterval += lOffset;
    
    lLocalNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:lTimeInterval];
    lLocalNotification.timeZone = [NSTimeZone localTimeZone];
    
    // Notification details
    lLocalNotification.alertBody = nil;
    lLocalNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:lLocalNotification];
    [lLocalNotification release];
}

- (void) addBonus {
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval lLastOpenedTime = [lUserDefaults doubleForKey:@"last_opened_time"];
    NSTimeInterval lNowTime = [[NSDate date] timeIntervalSince1970];
    if (lLastOpenedTime == 0.0) {
        lLastOpenedTime = lNowTime - 16 * STARS_FROM_TIME;
    }
    NSTimeInterval lDiffTime = lNowTime - lLastOpenedTime;
    if (lDiffTime > MIN_LAST_TIME) {
        [lUserDefaults setDouble:lNowTime forKey:@"last_opened_time"];
        [lUserDefaults synchronize];
        
        NSUInteger lStars = (NSUInteger)ceilf(lDiffTime / STARS_FROM_TIME);
        [[XCounter instance] addStars:lStars];
        
        XMessageView *lMessageView = [[XMessageView alloc] initWithTitle:@"Bonus" message:[NSString stringWithFormat:@"   + extra %i stars!!!\n ", lStars] delegate:nil cancelButtonTitle:@"OK"];
        
        CGPoint lCenter = CGPointMake(30.0, 45.0);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lCenter = CGPointMake(70.0, 105.0);
        }
        
        UIImageView *lStarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_yellow_%@.png", deviceType()]]];
        [lStarImageView setCenter:lCenter];
        [lMessageView addSubview:lStarImageView];
        [lStarImageView release];
        
        lCenter = CGPointMake(50.0, 15.0);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lCenter = CGPointMake(120.0, 45.0);
        }
        
        UIImageView *lStarImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_gray_%@.png", deviceType()]]];
        [lStarImageView2 setCenter:lCenter];
        [lMessageView addSubview:lStarImageView2];
        [lStarImageView2 release];
        
        lCenter = CGPointMake(60.0, 40.0);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            lCenter = CGPointMake(165.0, 90.0);
        }
        
        UIImageView *lStarImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_yellow_%@.png", deviceType()]]];
        [lStarImageView3 setCenter:lCenter];
        [lMessageView addSubview:lStarImageView3];
        [lStarImageView3 release];
        
        [lMessageView show];
        [lMessageView release];
    }
}

#pragma mark - UINavigationControllerDelegate -

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

}

#pragma showpopup
- (void)showPopup
{
    RevMobPopup *popup = [[RevMobAds session] popup];
    
    [popup loadWithSuccessHandler:^(RevMobPopup *popup) {
        [popup showAd];
        [self revmobAdDidReceive];
    } andLoadFailHandler:^(RevMobPopup *popup, NSError *error) {
        [self revmobAdDidFailWithError:error];
    } onClickHandler:^(RevMobPopup *popup) {
        [self revmobUserClickedInTheAd];
    }];
}

#pragma mark - revmob delegate implementation

- (void) revmobAdDidReceive
{
}

-(void) revmobAdDidFailWithError:(NSError *)error
{
	NSLog(@"revmob banner load error: %@", [error description]);
}

- (void) revmobUserClickedInTheAd
{
    
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == mAlertRevMob) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/wildfive/id601945307?mt=8"]];
        }
    }
}

- (void)showAdd {
    NSString *upgradekey = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".upgrade"];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:upgradekey]) {
		// Revmob
		//[[RevMobAds session] setTestingMode:RevMobAdsTestingModeWithAds];
        [[RevMobAds session] showFullscreen];
        
        // chartboost
		/*Chartboost *cb = [Chartboost sharedChartboost];
         cb.appId = @"51c86f1316ba47a42d000000";
         cb.appSignature = @"f2faed43a66009f20e133814e62d4894182a92ef";
         
         [cb startSession];
         
         [cb showInterstitial];*/
        
        [self showPopup];
        //        [self performSelectorInBackground:@selector(showPopup) withObject:nil];
	}
}

@end
