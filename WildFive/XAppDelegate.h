//
//  XAppDelegate.h
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/2/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <RevMobAds/RevMobAds.h>

#import "XReachabilityNet.h"

#define appDelegate ((XAppDelegate *)[[UIApplication sharedApplication] delegate])

extern NSString *const FBSessionStateChangedNotification;

@class XRootViewController;

@interface XAppDelegate : UIResponder <UINavigationControllerDelegate, UIApplicationDelegate, RevMobAdsDelegate> {
    XRootViewController *mRootViewController;
    
    XReachabilityNet                 *mHostReach;
	XReachabilityNetStatus        mNetStatus;
    
    UIAlertView *mAlertRevMob;
    
    UINavigationController *mNavigationController;
    BOOL mIsOnlineGame;
}
@property (nonatomic,readwrite) BOOL mIsOnlineGame;
@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic) XReachabilityNetStatus netStatus;
@property (nonatomic, readonly) XReachabilityNet *currentReachabilityNet;
@property (nonatomic, retain) XRootViewController *rootViewController;

- (void)updateInterfaceWithReachability: (XReachabilityNet*) pCurReach;

- (void)showAdd;

@end
