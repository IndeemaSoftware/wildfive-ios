//
//  XMessageView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 23/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMessageViewPositionTop,
    XMessageViewPositionCenter,
    XMessageViewPositionBottom
} XMessageViewPosition;

@class XMessageViewController;

@interface XMessageView : UIView <UITextFieldDelegate> {
    UIWindow *mWindow;
    NSMutableArray *mArrayOfButtons;
    
    UIView *mVisableView;
    
    UILabel *mTitleLable;
    UILabel *mMessageLable;
    
    UITextField *mTextField;
    
    UIButton *mCancelButton;
    
    XMessageViewController *mMessageController;
    
    XMessageViewPosition mPosition;
    
    CGFloat mTopIndent;
    CGFloat mBottomIndent;
    
    id mDelegate;
    
    BOOL mIsVisble;
    BOOL mCanMove;
    BOOL mIsEditing;
}
@property (nonatomic) XMessageViewPosition position;
@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) BOOL isVisible;

- (id)initWithTitle:(NSString *)pTitle message:(NSString *)pMessage delegate:(id)pDelegate cancelButtonTitle:(NSString *)pCancelButtonTitle;

- (void) show; 
- (void) hide;

- (void) starShowing; 

- (void) setTitle:(NSString*)pTitle;
- (void) setMessage:(NSString*)pMessage;
- (void) setTitleForCancelButton:(NSString*)pTitle;
- (void) setTitle:(NSString*)pTitle forButtonAtIndex:(NSUInteger)pIndex;
- (void) addButtonWithTitle:(NSString*)pButtonTitle;
- (void) addTextFieldWithPlaceHolder:(NSString*)pText;

@end