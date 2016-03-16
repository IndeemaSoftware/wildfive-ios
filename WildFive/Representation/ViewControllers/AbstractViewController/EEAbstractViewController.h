//
//  XAbstractViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 10/23/12.
//
//

#import <UIKit/UIKit.h>

@interface EEAbstractViewController : UIViewController <UIActionSheetDelegate> {
    
}

//back button
- (void) showBackButton;
- (void) hideBackButton;

//right button
- (void) showRightButton;
- (void) hideRightButton;
- (void) setRightButtonTitle:(NSString*)pTitle;

//hint button
- (void) showHintButton;
- (void) hideHintButton;
- (void) setHintCount:(NSUInteger)pHintCount;

- (void) addSwipeGesture;
- (void) backNavigationButtonPressed:(id)pSender;
- (void) rightNavigationButtonPressed:(id)pSender;
- (void) hintNavigationButtonPressed:(id)pSender;
@end
