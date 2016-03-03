//
//  XReachabilityNet.m
//  WildFive
//
//  Created by Yaroslav Rybiy on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "XReachabilityNet.h"
#import "Global.h"

#define kShouldPrintReachabilityFlags 1

static void PrintReachabilityFlags(SCNetworkReachabilityFlags    flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
	
    ALog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
			(flags & kSCNetworkReachabilityFlagsIsWWAN)				  ? 'W' : '-',
			(flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
			
			(flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
			(flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
			(flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
			(flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
			comment
			);
#endif
}


@implementation XReachabilityNet
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
	#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(NSObject*) info isKindOfClass: [XReachabilityNet class]], @"info was wrong class in ReachabilityCallback");

	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.
	NSAutoreleasePool* lPool = [[NSAutoreleasePool alloc] init];
	
	XReachabilityNet* lNoteObject = (XReachabilityNet*) info;
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: K_REACHABILITY_CHANGE_NOTIFICATION object: lNoteObject];
	
	[lPool release];
}

- (BOOL) startNotifier {
	BOOL lRetVal = NO;
	SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
	if(SCNetworkReachabilitySetCallback(mReachabilityRef, ReachabilityCallback, &context))
	{
		if(SCNetworkReachabilityScheduleWithRunLoop(mReachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
		{
			lRetVal = YES;
		}
	}
	return lRetVal;
}

- (void) stopNotifier {
	if(mReachabilityRef != NULL)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(mReachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

- (void) dealloc {
	[self stopNotifier];
	if(mReachabilityRef != NULL)	{
		CFRelease(mReachabilityRef);
	}
	[super dealloc];
}

+ (XReachabilityNet*) reachabilityWithHostName: (NSString*) pHostName {
	XReachabilityNet* lRetVal = NULL;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [pHostName UTF8String]);
	if(reachability!= NULL)
	{
		lRetVal= [[[self alloc] init] autorelease];
		if(lRetVal!= NULL)
		{
			lRetVal->mReachabilityRef = reachability;
			lRetVal->mLocalWiFiRef = NO;
		}
	}
	return lRetVal;
}

+ (XReachabilityNet*) reachabilityWithAddress: (const struct sockaddr_in*) pHostAddress {
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)pHostAddress);
	XReachabilityNet* retVal = NULL;
	if(reachability!= NULL)
	{
		retVal= [[[self alloc] init] autorelease];
		if(retVal!= NULL)
		{
			retVal->mReachabilityRef = reachability;
			retVal->mLocalWiFiRef = NO;
		}
	}
	return retVal;
}

+ (XReachabilityNet*) reachabilityForInternetConnection {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	return [self reachabilityWithAddress: &zeroAddress];
}

+ (XReachabilityNet*) reachabilityForLocalWiFi {
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	XReachabilityNet *lRetVal = [self reachabilityWithAddress: &localWifiAddress];
	if(lRetVal != NULL)	{
		lRetVal->mLocalWiFiRef = YES;
	}
	return lRetVal;
}

#pragma mark Network Flag Handling

- (XReachabilityNetStatus)localWiFiStatusForFlags:(SCNetworkReachabilityFlags)flags {
    
	PrintReachabilityFlags(flags, "localWiFiStatusForFlags");
	BOOL retVal = XReachabilityNetStatusNotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))	{
        
		retVal = XReachabilityNetStatusReachableViaWiFi;	
	}
	return retVal;
}

- (XReachabilityNetStatus) networkStatusForFlags: (SCNetworkReachabilityFlags)flags {
	PrintReachabilityFlags(flags, "networkStatusForFlags");
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
		// if target host is not reachable
		return XReachabilityNetStatusNotReachable;
	}

	BOOL lRetVal = XReachabilityNetStatusNotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		lRetVal = XReachabilityNetStatusReachableViaWiFi;
	}
	
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
		(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs

			if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
				// ... and no [user] intervention is needed
				lRetVal = XReachabilityNetStatusReachableViaWiFi;
			}
		}
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		lRetVal = XReachabilityNetStatusReachableViaWWAN;
	}
	return lRetVal;
}

- (BOOL) connectionRequired {
    
	NSAssert(mReachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(mReachabilityRef, &flags))
	{
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
	return NO;
}

- (XReachabilityNetStatus) currentReachabilityStatus {
    
	NSAssert(mReachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
	XReachabilityNetStatus lRetVal = XReachabilityNetStatusNotReachable;
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(mReachabilityRef, &flags))
	{
		if(mLocalWiFiRef) {
            
			lRetVal = [self localWiFiStatusForFlags:flags];
		}
		else {
			lRetVal = [self networkStatusForFlags:flags];
		}
	}
	return lRetVal;
}
@end
