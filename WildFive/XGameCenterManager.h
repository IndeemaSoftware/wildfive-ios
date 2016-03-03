//
//  XGameCenterManager.h
//  WildFive
//
//  Created by naceka on 13.02.12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h> 

#define kLeaderboardID @"grp.1.0.0"

@class GKLeaderboard, GKAchievement, GKPlayer,GKChallenge;
@protocol XGameCenterProtocolDelegate<NSObject>
@optional
- (void)addStarsForInviting;
@end
@interface XGameCenterManager : NSObject<GKFriendRequestComposeViewControllerDelegate> {

}
@property(nonatomic, assign)id delegate;

+ (id) instance;
- (void) authenticatePlayer;
+ (BOOL) checkNetStatus;
- (BOOL) isCheckAuticatePlayer;
- (void) submitScore:(int64_t)score;
- (void) inviteFriends:(UIViewController*)pController;
@end
