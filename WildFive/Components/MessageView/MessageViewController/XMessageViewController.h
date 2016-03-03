//
//  XMessageViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMessageViewController : NSObject {
    NSMutableArray *mArrayOfMessages;
    
    XMessageView *mCurrentMessageView;
}

//static methods
+ (XMessageViewController*) instance;
+ (void) release;

//
- (void) showMessageView:(XMessageView*)pMessageView;
- (void) hidedMessageView:(XMessageView*)pMessageView;
@end
