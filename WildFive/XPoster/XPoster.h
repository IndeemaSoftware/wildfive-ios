//
//  XPoster.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/TWRequest.h>

#import "XGameEnums.h"
#import "XMessageViewDelegate.h"

@class FacebookManager;

@interface XPoster : NSObject <XMessageViewDelegate> {
    FacebookManager *_facebookManager;
    NSUInteger mStarForPost;
}

+ (XPoster*) instance;

- (void) postOnFacebookWinForLevel:(XGameLevel)pLevel;
- (void) postOnFacebookCommon;
- (void) postInviteOnFacebook;

@end
