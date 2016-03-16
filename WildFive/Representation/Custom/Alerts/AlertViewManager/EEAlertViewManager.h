//
//  EEAlertViewManager.h
//  zipGo
//
//  Created by Volodymyr Shevchyk Jr on 2/9/16.
//  Copyright © 2016 zipGo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEAlertView.h"

@interface EEAlertViewManager : NSObject {
    UIWindow *_alertsWindow;
    NSMutableArray *_arrayOfAlertViews;
    
    EEAlertView *_currentAlertView;
}

+ (EEAlertViewManager*)sharedManager;
- (void)showAlert:(EEAlertView*)alertView;
- (void)dismissAlert:(EEAlertView*)alertView;
@end
