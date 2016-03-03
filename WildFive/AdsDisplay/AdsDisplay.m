//
//  AdsDisplay.m
//  Retirement_home_finder
//
//  Created by Oleg.Sehelin on 06.11.12.
//  Copyright (c) 2012 Space-O Infocom. All rights reserved.
//

#import "AdsDisplay.h"
#import "XAppDelegate.h"
#import "XInfoView.h"

@interface AdsDisplay()
- (UIViewController*) currentViewController;
- (void) showUpgadeAlertView;
@end

@implementation AdsDisplay

static AdsDisplay *mAdsDisplay = nil;
+(AdsDisplay*) initialise {
    @synchronized(self)
    {
        if (mAdsDisplay == nil) {
            mAdsDisplay = [[AdsDisplay alloc] init];
        }
    }
    
    return mAdsDisplay;
}

+ (void)release {
	[mAdsDisplay release];
	mAdsDisplay = nil;
}

- (id) init {
	self = [super init];
	if (self) {
        mInterstitialAdController = [MPInterstitialAdController interstitialAdControllerForAdUnitId:PUB_ID_FULL_SCREEN];
        mInterstitialAdController.delegate = self;
        [mInterstitialAdController loadAd];
        mTouchCount = AD_CLICKS_COUNT;
	}
	return self;
}

- (void)dealloc{
    XSafeRelease(mInterstitialAdController);
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:FULL_APP_VERSION_URL]];
    }
}

#pragma mark -Global methods-
- (void) changeTouchCount {
    mTouchCount--;
    NSLog(@"mTouchCount %i", mTouchCount);
    if (mTouchCount == 0) {
        if (mInterstitialAdController.ready) {
            [[XInfoView instance] hide];
            [mInterstitialAdController showFromViewController:[self currentViewController]];
        } else {
            [mInterstitialAdController loadAd];
        }
        
        mTouchCount = AD_CLICKS_COUNT;
    }
}

- (UIViewController*) currentViewController {
    UIViewController *lResult = nil;
    lResult = ((XAppDelegate*)[UIApplication sharedApplication].delegate).navigationController.visibleViewController;
    return lResult;
}

- (void) showUpgadeAlertView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *lAlertView = [[UIAlertView alloc] initWithTitle:@"Upgrade App" message:@"Tired of these ads? Upgrade\nthis app." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"OK",nil];
        [lAlertView show];
        [lAlertView release];
    });
}

#pragma mark -Flurry Ads Delegate methods-
#pragma mark Interstitial delegate methods
- (UIViewController *)viewControllerForPresentingModalView {
	return [self currentViewController];
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
	NSLog(@"Interstitial did load Ad: %@",interstitial);
}

- (void)dismissInterstitial:(MPInterstitialAdController *)interstitial {
	[[self currentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial{
	NSLog(@"Interstitial did fail to return ad %@",interstitial);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial{
	NSLog(@"Interstitial will appear: %@",interstitial);
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidDisappear: %@",interstitial);
    [self performSelector:@selector(showUpgadeAlertView) withObject:nil afterDelay:0.2];
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    [[XInfoView instance] show];
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    // Reload the interstitial ad, if desired.
    [mInterstitialAdController loadAd];
}


@end
