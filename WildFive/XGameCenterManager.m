//
//  XGameCenterManager.m
//  WildFive
//
//  Created by naceka on 13.02.12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XGameCenterManager.h"
#import "XAppDelegate.h"
#import "XGameViewControler.h"

#define ACHIEVEMENT_ID_1 @"grp.1.0.0.5"
#define ACHIEVEMENT_ID_2 @"grp.1.0.0.1"
#define ACHIEVEMENT_ID_3 @"grp.1.0.0.2"
#define ACHIEVEMENT_ID_4 @"grp.1.0.0.3"
#define ACHIEVEMENT_ID_5 @"grp.1.0.0.4"
#define ACHIEVEMENT_ID_6 @"grp.1.0.0.6"
#define ACHIEVEMENT_ID_7 @"grp.1.0.0.7"

#define ACHIEVEMENT_POINT_1 20.0
#define ACHIEVEMENT_POINT_2 150.0
#define ACHIEVEMENT_POINT_3 500.0
#define ACHIEVEMENT_POINT_4 1000.0
#define ACHIEVEMENT_POINT_5 1500.0
#define ACHIEVEMENT_POINT_6 5000.0
#define ACHIEVEMENT_POINT_7 10000.0

@interface XGameCenterManager()
@property(nonatomic, retain) NSMutableDictionary *achievementsDictionary;

- (void) localPlayerScore:(GKScore *)score error:(NSError *)error;
- (void) loadScore;

@end
@implementation XGameCenterManager
static XGameCenterManager *gCenterManager = nil;
@synthesize delegate;
@synthesize achievementsDictionary;

- (id) init {
    self = [super init];
    if (self)
    {
        self.achievementsDictionary = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}
- (void) authenticatePlayer {
    if([GKLocalPlayer localPlayer].authenticated == NO)
    {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            ALog(@"authenticateWithCompletionHandler %@", error);
            [self loadAchievements];
            DLog(@"authenticated");
        }];
    }
}

- (void) callDelegate:(SEL)selector withObject:(id)arg error:(NSError*)err {
	assert([NSThread isMainThread]);
	if([self respondsToSelector: selector])
	{
		if(arg != NULL) {
            
			[self performSelector:selector withObject:arg withObject:err];
		}
		else {
			[self performSelector: selector withObject: err];
		}
	}
	else {
		
	}
}
- (void) callDelegateOnMainThread:(SEL)selector withObject:(id)arg error:(NSError*)err {
	dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self callDelegate:selector withObject:arg error:err];
                   });
}
+ (BOOL) checkNetStatus {
    XAppDelegate * lAppDelegate = (XAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (lAppDelegate.netStatus != XReachabilityNetStatusNotReachable) {
        return YES;        
	}
    return NO;  
}
- (BOOL) isCheckAuticatePlayer {
    if([GKLocalPlayer localPlayer].authenticated == NO) {
        return NO;
    }
    return YES;
    
}
- (void) loadScore {
    GKLeaderboard *leaderBoardRequest = [[[GKLeaderboard alloc] init] autorelease];
    leaderBoardRequest.category = nil;
    [leaderBoardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error)
     {
         if (leaderBoardRequest.localPlayerScore != nil) {
             [self callDelegateOnMainThread:@selector(localPlayerScore:error:) withObject:leaderBoardRequest.localPlayerScore error:error];
         }
     }];
}
- (void) localPlayerScore:(GKScore *)score error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
    });
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        // Do something interesting here.
    }];
}

- (void) submitScore:(int64_t)score {    
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:LEADER_BOARD_CATEGORY] autorelease];
    scoreReporter.value = score;
    
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error){
        if(error != nil){
            ALog(@"Score Submission Failed");
        } else {
            ALog(@"Score Submitted");
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_1 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_1];
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_2 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_2];
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_3 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_3];
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_4 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_4];
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_5 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_5];
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_6 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_6];
            [self reportAchievementIdentifier:ACHIEVEMENT_ID_7 percentComplete:(scoreReporter.value + 0.0f) / ACHIEVEMENT_POINT_7];
        }
    }];
}

//achivements
- (void) loadAchievements {
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        if (achievements != nil)
        {
            for (GKAchievement* achievement in achievements) {
                [self.achievementsDictionary setObject: achievement forKey: achievement.identifier];
            }
        }
    }];
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier {
    GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
    if (achievement == nil)
    {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [self.achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return achievement;
    
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent {
    dispatch_async(dispatch_get_main_queue(), ^{
        float lRecent = percent * 100.0f;
        GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
        if (achievement)
        {
            if (lRecent < 0) {
                lRecent = 0;
            }
            if (lRecent > 100) {
                lRecent = 100;
            }
            achievement.percentComplete = lRecent;
            [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
                if (error != nil)
                {
                    DLog(@"reportAchievementWithCompletionHandler %@", error);
                }
            }];
        }
    });
    
}

+ (id) instance {
    if (gCenterManager == nil) {
        gCenterManager = [[XGameCenterManager alloc] init];
    }
    return gCenterManager;
}
#pragma mark - invite methods
- (void) inviteFriends:(UIViewController*)pController{
    GKLocalPlayer *lPlayer = [GKLocalPlayer localPlayer];
    if (lPlayer.authenticated)
    {
        DLog(@"lPlayer is authenticated");
        [lPlayer loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error) {
            if (friends != nil){
                DLog(@"There are some friends...");
                [GKPlayer loadPlayersForIdentifiers:friends withCompletionHandler:^(NSArray *players, NSError *error) {
                    if (error != nil){
                        DLog(@"invite ERROR:%@",error);
                    }
                    
                    if (players != nil){
                        DLog(@"players not nil");

                        
                         DLog(@"friends list: %@",players);
                        
//                        GKFriendRequestComposeViewController *friendRequestViewController = [[GKFriendRequestComposeViewController alloc] init];
//                        [friendRequestViewController setMessage:@"Let's play WildFive"];
// 
//                        
//                        friendRequestViewController.composeViewDelegate = self;
//                        if (players)
//                        {
//                            DLog(@"friends list: %@",players);
//                            [friendRequestViewController addRecipientsWithPlayerIDs: players];
//                        }
//                        [pController presentViewController: friendRequestViewController animated: YES completion:nil];
//                        [friendRequestViewController release];
            
                    }
                }];
            }
        }];
    }
}
- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController
{
    if (viewController.isBeingDismissed) {
        DLog(@"Dismissed...");
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    if (viewController.isBeingPresented) {
        DLog(@"Presented...");
        
    }
}

@end
