//
//  XInfoView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 2/5/13.
//
//

#import "XInfoView.h"
#import "XCounter.h"

static XInfoView *sXInfoView = nil;

@implementation XInfoView

+ (XInfoView*) instance {
    if (sXInfoView == nil) {
        sXInfoView = [[XInfoView alloc] initWithFrame:CGRectMake(0.0, -20.0, [UIScreen mainScreen].bounds.size.width, INFO_VIEW_HEIGHT)];
    }
    return sXInfoView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.529 green:0.933 blue:0.999 alpha:1.0]];
        [self setClipsToBounds:NO];
        
        UIImageView *lBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, INFO_VIEW_HEIGHT+5.0)];
        [lBackgroundImageView setImage:[UIImage imageNamed:@"cloud.png"]];
        [self addSubview:lBackgroundImageView];
        [lBackgroundImageView release];
        
        UIWindow *lWindow = [[UIApplication sharedApplication] keyWindow];
        [lWindow addSubview:self];
        
        mStarsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, self.frame.size.width / 2 - 5.0, self.frame.size.height)];
        [mStarsLabel setBackgroundColor:[UIColor clearColor]];
        [mStarsLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [mStarsLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [mStarsLabel setText:@"Stars:0"];
        [self addSubview:mStarsLabel];
        
        mHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0.0, self.frame.size.width / 2 - 5.0, self.frame.size.height)];
        [mHintLabel setBackgroundColor:[UIColor clearColor]];
        [mHintLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [mHintLabel setTextAlignment:NSTextAlignmentRight];
        [mHintLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [mHintLabel setText:@"Hints:0"];
        [self addSubview:mHintLabel];
    }
    return self;
}

- (void) setStarsCount:(NSUInteger)pStarsCount {
    [mStarsLabel setText:[NSString stringWithFormat:@"Stars:%i", pStarsCount]];
}

- (void) setHintsCount:(NSUInteger)pHintsCount {
    [mHintLabel setText:[NSString stringWithFormat:@"Hints:%i", pHintsCount]];
}

- (void) show {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [UIView commitAnimations];
}

- (void) hide {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [self setFrame:CGRectMake(0.0, -self.frame.size.height*2, self.frame.size.width, self.frame.size.height)];
    [UIView commitAnimations];
}

//- (void)removeFromSuperview {
//    
//}

- (void) dealloc {
    XSafeRelease(mStarsLabel);
    XSafeRelease(mHintLabel);
    [super dealloc];
}

@end
