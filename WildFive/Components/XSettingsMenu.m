//
//  XSettingsMenu.m
//  WildFive
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XSettingsMenu.h"
#import "Global.h"

#define MENU_GAME_SET_TITLE     NSLocalizedString(@"Game", @"SettingsMenuV") 
#define MENU_MUSIC_SET_TITLE    NSLocalizedString(@"Music", @"SettingsMenuV") 

@implementation XSettingsMenu
@synthesize lblTitle=mLblTitle;
@synthesize changeViewOnGame;
@synthesize changeViewOnMusic;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        mImgBgrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"board_set_menu@2x.png"]];
        mImgBgrView.frame = self.bounds;
        [self addSubview:mImgBgrView];
        mLblTitle = [[UILabel alloc] init];
        mLblTitle.backgroundColor = [UIColor clearColor];
        mLblTitle.frame = CGRectMake(0, CGRectGetMaxY(self.bounds)-25, self.bounds.size.width-5.0f, 20.0f);
        mLblTitle.textAlignment = NSTextAlignmentCenter;
        mLblTitle.center = CGPointMake(self.bounds.size.width/2.0f, mLblTitle.center.y);
        mLblTitle.text = MENU_GAME_SET_TITLE;
        [self addSubview:mLblTitle];
        state = XSettingsMenuChoiceGame;
        lock = NO;
   
    }
    return self;
}
- (void) unlockAnimation {
    lock = NO;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (NO == lock) {
        [self performSelector:@selector(unlockAnimation) withObject:nil afterDelay:MENU_DURATION];
        lock = YES;
        switch (state) {
            case XSettingsMenuChoiceGame:
                state = XSettingsMenuChoiceMusic;
                mLblTitle.text = MENU_MUSIC_SET_TITLE;
                if ([self changeViewOnMusic]) {
                    [self changeViewOnMusic]();
                }
                break;
                
            case XSettingsMenuChoiceMusic:
                state = XSettingsMenuChoiceGame;
                mLblTitle.text = MENU_GAME_SET_TITLE;
                if ([self changeViewOnGame]) {
                    [self changeViewOnGame]();
                }
                break;
        }  
    }  
}
- (void) dealloc {
    XSafeRelease(mImgBgrView);
    XSafeRelease(mLblTitle);
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
