//
//  EEAlertView_HiddenInterface.h
//  zipGo
//
//  Created by Volodymyr Shevchyk Jr on 2/9/16.
//  Copyright © 2016 zipGo. All rights reserved.
//

#import "EEAlertView.h"

@interface EEAlertView () {
    
}

@property (nonatomic, weak) UIWindow *lastActiveWindow;
@property (nonatomic, readwrite) CGFloat alertVerticalRatio;

- (IBAction)buttonPressed:(id)sender;

@end
