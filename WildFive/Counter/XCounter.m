//
//  XCounter.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 2/4/13.
//
//

#import "XCounter.h"
#import "XInfoView.h"
#import "XGameCenterManager.h"

#define STARS_COUNT @"starts_count"
#define STARS_FOR_HINT_COUNT @"starts_for_hint_count"
#define HINT_COUNT @"hints_count"
#define STARS_MAX_COUNT @"stars_max_count"

static XCounter *sXCounter = nil;

@interface XCounter()
- (void) updateInfoView;
@end

@implementation XCounter

@synthesize starCount=mStartCount;
@synthesize hintCount=mHintCount;
@synthesize hintButtonIndex = mHintButtonIndex;
#pragma mark - Static methods
+ (XCounter*) instance {
    if (sXCounter == nil) {
        sXCounter = [[XCounter alloc] init];
    }
    return sXCounter;
}

#pragma mark - Unstatic methods
- (id) init {
    self = [super init];
    if (self) {
        NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
        mStartCount = [lUserDefaults integerForKey:STARS_COUNT];
        mStartForHintCount = [lUserDefaults integerForKey:STARS_FOR_HINT_COUNT];
        mHintCount = [lUserDefaults integerForKey:HINT_COUNT];
        mStarsMaxCount = [lUserDefaults floatForKey:STARS_MAX_COUNT];
        
        if (mStarsMaxCount == 0) {
            mStarsMaxCount = 16.0;
        }
        
        DLog(@"mStartCount %i", mStartCount);
        DLog(@"mHintCount %i", mHintCount);
        [self updateInfoView];
    }
    return self;
}

- (void) updateInfoView {
    [[XInfoView instance] setStarsCount:mStartCount];
    [[XInfoView instance] setHintsCount:mHintCount];
}

- (NSUInteger) addStars:(NSUInteger)pCount {
    mStartCount += pCount;
    mStartForHintCount += pCount;
    if (mStartForHintCount >= mStarsMaxCount) {
        NSUInteger lHints = (NSUInteger)floor(mStartForHintCount / mStarsMaxCount);
        mStartForHintCount = mStartForHintCount - lHints * (NSUInteger)mStarsMaxCount;
        mHintCount += lHints;
        
        if (mStarsMaxCount == 16.0) {
            mStartForHintCount = 16;
        }
        mStarsMaxCount += 4.0;
    }
    [self updateInfoView];
    [[XGameCenterManager instance] submitScore:mStartCount];
    return mStartCount;
}
-(NSUInteger)addHints{
    DLog(@"Hints added!!!");
    NSInteger lHintsToAdd;
    if(mHintButtonIndex == 0){
        lHintsToAdd = 100;
    }else if(mHintButtonIndex == 1){
        if (IS_FREE_VERSION) {
            lHintsToAdd = 35;
        }else{
            lHintsToAdd = 25;
        }
    }
    mHintCount +=lHintsToAdd;
    [[NSUserDefaults standardUserDefaults] setInteger:mHintCount forKey:HINT_COUNT];
    
//    UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                          message:[NSString stringWithFormat:@"You have successfully purchased %i hints",lHintsToAdd]
//                                                         delegate:self
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//    [simpleAlert show];
//    [simpleAlert release];
    XMessageView *lMessageView = [[XMessageView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:NSLocalizedString(@"You have successfully purchased %i hints",@"Purchasing"),lHintsToAdd] delegate:nil cancelButtonTitle:@"OK"];
    [lMessageView show];
    [lMessageView release];
    
    [self updateInfoView];
    return mHintCount;
}


//increment 1 hint and return current hint count
- (NSUInteger) useHint {
    if (mHintCount > 0) {
        mHintCount--;
    }
    [self updateInfoView];
    return mHintCount;
}

- (void) save {
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    [lUserDefaults setInteger:mStartCount forKey:STARS_COUNT];
    [lUserDefaults setInteger:mStartForHintCount forKey:STARS_FOR_HINT_COUNT];
    [lUserDefaults setInteger:mHintCount forKey:HINT_COUNT];
    [lUserDefaults setFloat:mStarsMaxCount forKey:STARS_MAX_COUNT];
    [lUserDefaults synchronize];
    
    [[XGameCenterManager instance] submitScore:mStartCount];
}

- (void)dealloc {
    [super dealloc];
}

@end
