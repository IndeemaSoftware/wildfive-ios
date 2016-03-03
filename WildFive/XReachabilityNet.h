//
//  XReachabilityNet.h
//  WildFive
//
//  Created by Yaroslav Rybiy on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <netinet/in.h>

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
	XReachabilityNetStatusNotReachable = 0,
	XReachabilityNetStatusReachableViaWiFi,
	XReachabilityNetStatusReachableViaWWAN
} XReachabilityNetStatus;
#define K_REACHABILITY_CHANGE_NOTIFICATION @"kNetworkReachabilityChangedNotification"

@interface XReachabilityNet: NSObject
{
	BOOL mLocalWiFiRef;
	SCNetworkReachabilityRef mReachabilityRef;
}

//reachabilityWithHostName- Use to check the reachability of a particular host name. 
+ (XReachabilityNet*) reachabilityWithHostName: (NSString*) pHostName;

//reachabilityWithAddress- Use to check the reachability of a particular IP address. 
+ (XReachabilityNet*) reachabilityWithAddress: (const struct sockaddr_in*) pHostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.  
//  Should be used by applications that do not connect to a particular host
+ (XReachabilityNet*) reachabilityForInternetConnection;

//reachabilityForLocalWiFi- checks whether a local wifi connection is available.
+ (XReachabilityNet*) reachabilityForLocalWiFi;

//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifier;
- (void) stopNotifier;

- (XReachabilityNetStatus) currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL) connectionRequired;
@end


