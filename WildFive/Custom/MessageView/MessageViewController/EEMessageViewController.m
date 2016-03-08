//
//  XMessageViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EEMessageViewController.h"

static EEMessageViewController *sSharedMessageController = nil;

@interface EEMessageViewController()
- (void) showNextMessageView;
@end

@implementation EEMessageViewController 

#pragma mark - Static methods
+ (EEMessageViewController*) instance {
    if (sSharedMessageController == nil) {
        sSharedMessageController = [[EEMessageViewController alloc] init];
    }
    return sSharedMessageController;
}

- (id)init {
    self = [super init];
    if (self) {
        mArrayOfMessages = [[NSMutableArray alloc] init];
        mCurrentMessageView = nil;
    }
    return self;
}

- (void) showMessageView:(EEMessageView*)pMessageView {
    if (pMessageView != nil) {
        [mArrayOfMessages addObject:pMessageView];
        if (mCurrentMessageView == nil) {
            mCurrentMessageView = pMessageView;
            [pMessageView starShowing];
        }
        
    }
}

- (void) hidedMessageView:(EEMessageView*)pMessageView {
    if (pMessageView != nil) {
        [mArrayOfMessages removeObject:pMessageView];
        if ([mCurrentMessageView isEqual:pMessageView]) {
            mCurrentMessageView = nil;
            [self showNextMessageView];
        }
    }
}

- (void) showNextMessageView {
    if ([mArrayOfMessages count] > 0) {
        EEMessageView *lMessageView = [mArrayOfMessages objectAtIndex:0];
        mCurrentMessageView = lMessageView;
        [lMessageView starShowing];
    }
}

- (void)dealloc {
    [mArrayOfMessages removeAllObjects];
}

@end
