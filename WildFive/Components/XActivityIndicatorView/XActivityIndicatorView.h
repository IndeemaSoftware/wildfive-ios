//
//  XActivityIndicatorView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XActivityIndicatorView : UIView {
    UIActivityIndicatorView *mActivityIndicator;
    UILabel *mMessageLable;
    UIButton *mCancelButton;
    
    id mDelegate;
    
    BOOL mHasCancelButton;
    BOOL mHasMessage;
}
@property (nonatomic, assign) id delegate;

- (void) setMessage:(NSString*)pMessage;
- (void) setHasCancelButton:(BOOL)pHasButton;

@end
