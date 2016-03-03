//
//  XPoster.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "XPoster.h"
#import "XMessageView.h"
#import "FacebookManager.h"
#import "XCounter.h"

static XPoster *sFacebookPoster = nil;
static NSObject *_syncObject = nil;

@interface XPoster()
- (void) showMessageForLevel:(XGameLevel)pLevel;
- (void) postHardWin;
- (void) postMediumWin;
- (void) postEasyWin;
- (void) handleResultAfterPost:(NSError *)error;
- (void) postAndHandlerOnFacebook:(NSDictionary *)parameters withSelector:(SEL)selector;
@end

@implementation XPoster

+ (void)initialize {
    _syncObject = [[NSObject alloc] init];
}
- (id)init {
    if (self = [super init]) {
        _facebookManager = [FacebookManager instance];
    }
    return self;
}
+ (XPoster*) instance {
    if (sFacebookPoster == nil) {
        @synchronized(_syncObject) {
            if (sFacebookPoster == nil) {
                sFacebookPoster = [[XPoster alloc] init];
            }
        }
        
    }
    return sFacebookPoster;
}

/*+ (void) release {
    if (sFacebookPoster != nil) {
        [sFacebookPoster release];
    }
}

- (id) retain {
    return self;
}

- (id) autorelease {
    return self;
}*/


- (void) showMessageForLevel:(XGameLevel)pLevel {
    NSString *lMessage = NSLocalizedString(@"", @"XPoster");
    if (pLevel == XGameLevelEasy) {
        lMessage = NSLocalizedString(@"Easy", @"XPoster");
    } else if (pLevel == XGameLevelMedium) {
        lMessage = NSLocalizedString(@"Middle", @"XPoster");
    } else if (pLevel == XGameLevelHard) {
        lMessage = NSLocalizedString(@"Hard", @"XPoster");
    } else {
        return;
    }
    XMessageView *lMessageView = [[XMessageView alloc] initWithTitle:lMessage  message:NSLocalizedString(@"You have just won. Would you like to share it?", @"PosterVC") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"PosterVC")];
    [lMessageView addButtonWithTitle:NSLocalizedString(@"Post", @"PosterVC")];
    [lMessageView setTag:pLevel];
    [lMessageView show];
    [lMessageView release];
}
#pragma mark -post
- (void) postOnFacebookWinForLevel:(XGameLevel)pLevel {
    DLog(@"_________after Poster___________");
    DLog(@"easy :%@",[[NSUserDefaults standardUserDefaults] objectForKey:WINS_EASY_PLAYER]);
    DLog(@"hard :%@",[[NSUserDefaults standardUserDefaults] objectForKey:WINS_HARD_PLAYER]);
    DLog(@"medium :%@",[[NSUserDefaults standardUserDefaults] objectForKey:WINS_MEDIUM_PLAYER]);
    mStarForPost = STARS_FOR_POST;
    
    NSString *lLevelKey = @"";
    if (pLevel == XGameLevelEasy) {
        lLevelKey = WINS_EASY_PLAYER;
    } else if (pLevel == XGameLevelMedium) {
        lLevelKey = WINS_MEDIUM_PLAYER;
    } else if (pLevel == XGameLevelHard) {
        lLevelKey = WINS_HARD_PLAYER;
    } else {
        return;
    }
    NSNumber *lNumberOfWins = [[NSUserDefaults standardUserDefaults] objectForKey:lLevelKey];
    if (lNumberOfWins == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:lLevelKey];
        //post
        [self showMessageForLevel:pLevel];
    } else {
        NSInteger lWins = [lNumberOfWins integerValue];
        lWins++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:lWins] forKey:lLevelKey];
        if((lWins % 10)==0){        
            [self showMessageForLevel:pLevel];
        }else{
            DLog(@"lWins : %i",lWins);
        }
        
    }
}

- (void) postOnFacebookCommon {
    mStarForPost = STARS_FOR_POST;
    
    NSMutableDictionary *lPostParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        APP_STORE_LINK, @"link",
                                        APP_ICON_LINK, @"picture",
                                        @"WildFive", @"name",
                                        @"I play WildFive with my friends. Connect to us and enjoy it.", @"caption",
                                        nil];
    [lPostParams setValue:_facebookManager.session.accessToken forKey:@"access_token"];
    
    SEL selector = @selector(postOnFacebookCommon);
    [self postAndHandlerOnFacebook:lPostParams withSelector:selector];
    
    [lPostParams release];    
}

- (void) postInviteOnFacebook {
    mStarForPost = STARS_FOR_INVITE;
    
    NSMutableDictionary *lPostParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        APP_STORE_LINK, @"link",
                                        APP_ICON_LINK, @"picture",
                                        @"WildFive", @"name",
                                        @"We play WildFive with friends. Connect to us and enjoy it.", @"caption",
                                        nil];
    [lPostParams setValue:_facebookManager.session.accessToken forKey:@"access_token"];
    
    SEL selector = @selector(postInviteOnFacebook);
    [self postAndHandlerOnFacebook:lPostParams withSelector:selector];
    
    [lPostParams release];
}

- (void) postHardWin {
    NSMutableDictionary *lPostParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 APP_STORE_LINK, @"link",
                                 APP_ICON_LINK, @"picture",
                                 @"WildFive", @"name",
                                 @"Man you are realy cool! You WON!", @"caption",                                 
                                 nil];
    
    [lPostParams setValue:_facebookManager.session.accessToken forKey:@"access_token"];
    
    SEL selector = @selector(postHardWin);
    [self postAndHandlerOnFacebook:lPostParams withSelector:selector];
    
    [lPostParams release];
}

- (void) postMediumWin {
    NSMutableDictionary *lPostParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 APP_STORE_LINK, @"link",
                                 APP_ICON_LINK, @"picture",
                                 @"WildFive", @"name",
                                 @"Congratulations you won!", @"caption",                                 
                                 nil];
    [lPostParams setValue:_facebookManager.session.accessToken forKey:@"access_token"];
    
    SEL selector = @selector(postMediumWin);
    [self postAndHandlerOnFacebook:lPostParams withSelector:selector];
    
    [lPostParams release];
}

- (void) postEasyWin {
    NSMutableDictionary *lPostParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 APP_STORE_LINK, @"link",
                                 APP_ICON_LINK, @"picture",
                                 @"WildFive", @"name",
                                 @"Well done. You won.", @"caption",
                                 nil];
    [lPostParams setValue:_facebookManager.session.accessToken forKey:@"access_token"];
    
    SEL selector = @selector(postEasyWin);
    [self postAndHandlerOnFacebook:lPostParams withSelector:selector];
    
    [lPostParams release];
}
- (void) postAndHandlerOnFacebook:(NSDictionary *)parameters withSelector:(SEL)selector {
    if (_facebookManager.session.accessToken.length > 0) {
        [_facebookManager postMessageOnFeed:parameters handler:^(FBRequestConnection *connection, id result, NSError *error) {
            [self handleResultAfterPost:error];
        }];
    }else {
        [_facebookManager connectToFacebook:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error == nil) {
                [self performSelector:selector];              
            }       
            
        }];
    }
}
- (void) handleResultAfterPost:(NSError *)error {
    NSString *lAlertText;
    if (error) {
        lAlertText = [NSString stringWithFormat:
                      @"error: domain = %@, code = %d",
                      error.domain, error.code];
    } else {
        lAlertText = [NSString stringWithFormat:@"Posted"];
        [[XCounter instance] addStars:mStarForPost];
    }
    // Show the result in an alert
    XMessageView *lMessageView = [[XMessageView alloc] initWithTitle:@"Result" message:lAlertText delegate:nil cancelButtonTitle:@"OK!"];
    
    [lMessageView show];
    [lMessageView release];
}
#pragma mark -
- (void) messageView:(XMessageView*)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex {
    if (pButtonIndex == 0) {
        if (pMessageView.tag == XGameLevelEasy) {
            [self postEasyWin];
        } else if (pMessageView.tag == XGameLevelMedium) {
            [self postMediumWin];
        } else if (pMessageView.tag == XGameLevelHard) {
            [self postHardWin];
        }
    }
}

-(void)messageViewCancelButtonPressed:(XMessageView *)pMessageView {
    
}

- (void)messageView:(XMessageView *)pMessageView endEditingTextField:(NSString *)pTextValue {
    
}

@end
