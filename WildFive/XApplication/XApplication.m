//
//  XApplication.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 11/11/12.
//
//

#import "XApplication.h"
#import "AdsDisplay.h"

@implementation XApplication

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (IS_FREE_VERSION) {
        UITouch *lTouch = [[event touchesForWindow:self.delegate.window] anyObject];
        if (lTouch != nil) {
            if (lTouch.window.windowLevel < 1500) {
                if (lTouch.phase == UITouchPhaseEnded) {
                    [[AdsDisplay initialise] changeTouchCount];
                }
            }
        }
    }
}
@end
