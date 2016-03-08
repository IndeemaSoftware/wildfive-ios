//
//  XMessageViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEMessageViewController : NSObject {
    NSMutableArray *mArrayOfMessages;
    
    EEMessageView *mCurrentMessageView;
}

//static methods
+ (EEMessageViewController*)instance;

//
- (void)showMessageView:(EEMessageView*)pMessageView;
- (void)hidedMessageView:(EEMessageView*)pMessageView;
@end
