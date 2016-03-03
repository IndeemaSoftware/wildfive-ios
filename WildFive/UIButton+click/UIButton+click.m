//
//  UIButton+click.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 10/9/12.
//
//

#import "UIButton+click.h"
#import "XSoundEngine.h"

@implementation UIButton (click)

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [super addTarget:target action:action forControlEvents:controlEvents];
    [super addTarget:[XSoundEngine sharedEngine] action:@selector(playSoundButtonClick) forControlEvents:UIControlEventTouchDown];
}

@end
