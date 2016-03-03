//
//  XMessageViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMessageViewController.h"

static XMessageViewController *sSharedMessageController = nil;

@interface XMessageViewController()
- (void) showNextMessageView;
@end

@implementation XMessageViewController 

#pragma mark - Static methods
+ (XMessageViewController*) instance {
    if (sSharedMessageController == nil) {
        sSharedMessageController = [[XMessageViewController alloc] init];
    }
    return sSharedMessageController;
}

+ (void) release {
    if (sSharedMessageController != nil) {
        [sSharedMessageController release];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        mArrayOfMessages = [[NSMutableArray alloc] init];
        mCurrentMessageView = nil;
    }
    return self;
}

- (id) retain {
    return self;
}

- (id) autorelease {
    return self;
}

- (void) showMessageView:(XMessageView*)pMessageView {
    if (pMessageView != nil) {
        [mArrayOfMessages addObject:pMessageView];
        if (mCurrentMessageView == nil) {
            mCurrentMessageView = pMessageView;
            [pMessageView starShowing];
        }
        
    }
}

- (void) hidedMessageView:(XMessageView*)pMessageView {
    if (pMessageView != nil) {
        [pMessageView retain];
        [mArrayOfMessages removeObject:pMessageView];
        if ([mCurrentMessageView isEqual:pMessageView]) {
            mCurrentMessageView = nil;
            [self showNextMessageView];
        }
        [pMessageView release];
    }
}

- (void) showNextMessageView {
    if ([mArrayOfMessages count] > 0) {
        XMessageView *lMessageView = [mArrayOfMessages objectAtIndex:0];
        mCurrentMessageView = lMessageView;
        [lMessageView starShowing];
    }
}

- (void)dealloc {
    [mArrayOfMessages removeAllObjects];
    [mArrayOfMessages release];
    [super dealloc];
}

@end
