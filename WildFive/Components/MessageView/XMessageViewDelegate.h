//
//  XMessageViewDelegate.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 23/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMessageView;
@protocol XMessageViewDelegate <NSObject>
- (void) messageView:(XMessageView*)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex;
- (void) messageViewCancelButtonPressed:(XMessageView*)pMessageView;
- (void) messageView:(XMessageView*)pMessageView endEditingTextField:(NSString*)pTextValue;
@end
