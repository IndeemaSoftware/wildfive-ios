//
//  FacebookManager.m
//  WildFive
//
//  Created by Admin on 02/02/2013.
//
//

#import "FacebookManager.h"
@interface FacebookManager()
//@property(nonatomic, strong) FBSession *session;
@end
@implementation FacebookManager
static FacebookManager *_instance = nil;
static NSObject *_syncObject = nil;

+(void)initialize{
    _syncObject = [[NSObject alloc] init];
}
- (id)init {
    self = [super init];
    if (self) {
        if (!_session.isOpen){
            NSArray *permitions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
            _session = [[FBSession alloc] initWithPermissions:permitions];
            [permitions release];
        }       
    }
    return self;
}
+ (id) instance {
    if (_instance == nil) {
        @synchronized(_syncObject){
            if (_instance == nil) {
                _instance = [[FacebookManager alloc] init];
            }
        }
    }
    return _instance;
}
- (BOOL) handleUrlForSession:(NSURL *)url {
    return [_session handleOpenURL:url];
}
- (void) connectToFacebook:(GetFbSessionStateHandler)handler {
    // this button's job is to flip-flop the session from open to closed
    if (_session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [_session closeAndClearTokenInformation];
        
    } else {
        if (_session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            
        //for permissions
           NSArray *permitions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
            _session = [[FBSession alloc] initWithPermissions:permitions];
            [permitions release];
            
        }
        
        [_session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView completionHandler:^(FBSession *session,
                                                                                                     FBSessionState status,
                                                                                                     NSError *error) {
            
            handler(session, status, error);
        }];      
        
    }
}
- (void) postMessageOnFeed:(NSDictionary *)parameters handler:(GetFbPostMessageOnFeedResult)handler {
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:parameters
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              handler(connection, result, error);                              
                          }];
}
- (BOOL) isSessionActive {
    if (_session.state == FBSessionStateCreatedTokenLoaded) {
        return YES;
    }
    return NO;
}
- (void) dealloc {    
//    self.session = nil;
    [super dealloc];
}
@end
