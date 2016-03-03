//
//  XInfoView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 2/5/13.
//
//

#import <UIKit/UIKit.h>

#define INFO_VIEW_HEIGHT 20.0

@interface XInfoView : UIView {
    UIWindow *mWindow;
    UILabel *mStarsLabel;
    UILabel *mHintLabel;
}

+ (XInfoView*) instance;

- (void) setStarsCount:(NSUInteger)pStarsCount;
- (void) setHintsCount:(NSUInteger)pHintsCount;
- (void) show;
- (void) hide;
@end
