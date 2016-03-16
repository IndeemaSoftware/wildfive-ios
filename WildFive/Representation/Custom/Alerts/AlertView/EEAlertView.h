//
//  EEAlertView.h
//  zipGo
//
//  Created by Volodymyr Shevchyk Jr on 2/9/16.
//  Copyright © 2016 zipGo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EEAlertViewDelegate;
@interface EEAlertView : UIView {

}

@property (nonatomic, weak) id <EEAlertViewDelegate> delegate;

+ (instancetype)createAlerViewWithNib:(NSString*)nib;
+ (instancetype)createAlerView;

- (void)show;
- (void)dismiss;
- (void)dismissAfter:(NSTimeInterval)afterTime;

@end

@protocol EEAlertViewDelegate <NSObject>
- (void)EEAlertView:(EEAlertView*)alertView buttonPressed:(NSUInteger)buttonIndex;
@end
