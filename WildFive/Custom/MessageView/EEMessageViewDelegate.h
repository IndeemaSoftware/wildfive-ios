//
//  XMessageViewDelegate.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 23/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EEMessageView;
@protocol EEMessageViewDelegate <NSObject>
- (void) messageView:(EEMessageView*)pMessageView clickedButtonAtIndex:(NSInteger)pButtonIndex;
- (void) messageViewCancelButtonPressed:(EEMessageView*)pMessageView;
- (void) messageView:(EEMessageView*)pMessageView endEditingTextField:(NSString*)pTextValue;
@end
