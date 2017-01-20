//
//  AppDelegate.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/5/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "EEMenuViewController.h"

#import <GameKit/GameKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface AppDelegate () {
    UINavigationController *_navigationController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *lRootViewController = nil;
    if( [deviceType() isEqualToString:IPHONE]) {
        lRootViewController = [[EEMenuViewController alloc] initWithNibName:@"EEMenuViewController" bundle:nil];
    } else if([deviceType() isEqualToString:IPAD]){
        lRootViewController = [[EEMenuViewController alloc] initWithNibName:@"EEMenuViewController_iPad" bundle:nil];
    }
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:lRootViewController];
//    _navigationController.delegate = self;
    [_navigationController setNavigationBarHidden:YES];
    //setting background image for navigation bar (only for iOS 5.0 and higher)

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:_navigationController];
    [self.window makeKeyAndVisible];
    
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        if(viewController)
        {
            [_navigationController presentViewController:viewController animated:YES completion:nil];
        }
        else if(localPlayer.isAuthenticated == YES)
        {
            [localPlayer generateIdentityVerificationSignatureWithCompletionHandler:^(NSURL *publicKeyUrl, NSData *signature, NSData *salt, uint64_t timestamp, NSError *error) {
                
                if(error != nil)
                {
                    return; //some sort of error, can't authenticate right now
                }
                
                [self verifyPlayer:localPlayer.playerID publicKeyUrl:publicKeyUrl signature:signature salt:salt timestamp:timestamp];
                
                
            }];
        } else {
            NSLog(@"game center disabled");
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)verifyPlayer:(NSString *)playerID publicKeyUrl:(NSURL *)publicKeyUrl signature:(NSData *)signature salt:(NSData *)salt timestamp:(uint64_t)timestamp
{
    //get certificate
    NSData *certificateData = [NSData dataWithContentsOfURL:publicKeyUrl];
    
    //build payload
    NSMutableData *payload = [[NSMutableData alloc] init];
    [payload appendData:[playerID dataUsingEncoding:NSASCIIStringEncoding]];
    [payload appendData:[[[NSBundle mainBundle] bundleIdentifier] dataUsingEncoding:NSASCIIStringEncoding]];
    
    uint64_t timestampBE = CFSwapInt64HostToBig(timestamp);
    [payload appendBytes:&timestampBE length:sizeof(timestampBE)];
    [payload appendData:salt];
    
    //sign
    SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData); // load the certificate
    SecPolicyRef secPolicy = SecPolicyCreateBasicX509();
    
    SecTrustRef trust;
    OSStatus statusTrust = SecTrustCreateWithCertificates( certificateFromFile, secPolicy, &trust);
    if(statusTrust != errSecSuccess)
    {
        NSLog(@"could not create trust");
        return;
    }
    
    SecTrustResultType resultType;
    OSStatus statusTrustEval =  SecTrustEvaluate(trust, &resultType);
    if(statusTrustEval != errSecSuccess)
    {
        NSLog(@"could not evaluate trust");
        return;
    }
    
    if(resultType != kSecTrustResultProceed && resultType != kSecTrustResultRecoverableTrustFailure)
    {
        NSLog(@"server can not be trusted");
        return;
    }
    
    SecKeyRef publicKey = SecTrustCopyPublicKey(trust);
    uint8_t sha256HashDigest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([payload bytes], (CC_LONG)[payload length], sha256HashDigest);
    
    //check to see if its a match
    OSStatus verficationResult = SecKeyRawVerify(publicKey,  kSecPaddingPKCS1SHA256, sha256HashDigest, CC_SHA256_DIGEST_LENGTH, (const uint8_t *)[signature bytes], [signature length]);
    
    CFRelease(publicKey);
    CFRelease(trust);
    CFRelease(secPolicy);
    CFRelease(certificateFromFile);
    if (verficationResult == errSecSuccess)
    {
        NSLog(@"Verified");
    }
    else
    {
        NSLog(@"Danger!!!");
    }
}

@end
