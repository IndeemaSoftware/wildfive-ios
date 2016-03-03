//
//  XCounter.h
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 2/4/13.
//
//

#import <Foundation/Foundation.h>

@interface XCounter : NSObject {
    NSUInteger mStartCount;
    NSUInteger mStartForHintCount;
    NSUInteger mHintCount;
    CGFloat mStarsMaxCount;
    NSUInteger mHintButtonIndex;
}

@property (nonatomic, readonly) NSUInteger starCount;
@property (nonatomic, readonly) NSUInteger hintCount;
@property (nonatomic, readwrite) NSUInteger hintButtonIndex;
//static
+ (XCounter*) instance;

//unstatic
- (NSUInteger) addStars:(NSUInteger)pCount;
- (NSUInteger) addHints;
- (NSUInteger) useHint;
- (void) save;
@end
