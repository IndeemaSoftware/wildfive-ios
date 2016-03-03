//
//  FacebookManager.h
//  WildFive
//
//  Created by Admin on 02/02/2013.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager : NSObject

@property(nonatomic, strong) FBSession *session;

typedef void (^GetFbSessionStateHandler)(FBSession *session, FBSessionState status, NSError *error);
typedef void (^GetFbPostMessageOnFeedResult)(FBRequestConnection *connection, id result, NSError *error);

- (BOOL) handleUrlForSession:(NSURL *)url;
- (void) connectToFacebook:(GetFbSessionStateHandler)handler;
- (void) postMessageOnFeed:(NSDictionary *)parameters handler:(GetFbPostMessageOnFeedResult)handler;
- (BOOL) isSessionActive;
+ (id) instance;
@end
