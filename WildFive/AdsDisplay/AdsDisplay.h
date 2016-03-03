//
//  AdsDisplay.h
//  Retirement_home_finder
//
//  Created by Oleg.Sehelin on 06.11.12.
//  Copyright (c) 2012 Space-O Infocom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPAdView.h"
#import "MPInterstitialAdController.h"

@interface AdsDisplay : NSObject <MPAdViewDelegate, MPInterstitialAdControllerDelegate, UIAlertViewDelegate>{
    @private UIView *mDisplayView;
    @private NSInteger mTouchCount;
    
    MPInterstitialAdController *mInterstitialAdController;
}

+ (AdsDisplay*) initialise;
+ (void)release;

- (void) changeTouchCount;
@end
