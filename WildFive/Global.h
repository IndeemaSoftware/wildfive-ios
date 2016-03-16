//
//  Global.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/5/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#ifndef WildFive_Global_h
#define WildFive_Global_h

#define ANIMATION_ON_STARTUP NO //set YES or NO
//#define ANIMATION_ON_STARTUP YES //set YES or NO

#define VKSafeTimerRelease(Timer) \
if (Timer != nil) {\
    if ([Timer isValid]) {\
        [Timer invalidate];\
        Timer = nil;\
    } \
}

#define XSafeRelease(Object) \
if (Object != nil) {\
    [Object release];\
    Object = nil;\
}

#define TIME_OUT 60
#define TIME_INTERVAL 86400

#define HINT_COUNT @"hints_count"
#define FULL_APP_VERSION_URL @""
#define AD_CLICKS_COUNT 40

//debug log
#ifdef DEBUG 
# define DLog(...) NSLog(__VA_ARGS__) 
#else 
# define DLog(...) /* */
#endif 
#define ALog(...) NSLog(__VA_ARGS__)
 
//#define APP_STORE_LINK @"itms-apps://itunes.apple.com/app/wildfive/id568063551?ls=1&mt=8"
#define APP_STORE_LINK @"https://itunes.apple.com/app/wildfivepaid/id601945307?ls=1&mt=8"
//@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa"
#define APP_ICON_LINK @"https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-ash3/64880_481494851898344_176967093_n.png"

#define DOCUMENTS_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//font
#define FONT @"AmericanTypewriter"
#define FONT_BOLD @"AmericanTypewriter-Bold"

//defice type
#define IPHONE @"iPhone"
#define IPAD @"iPad"

//winning type
#define WINS_HARD_PLAYER    @"wins_hard_player"
#define WINS_MEDIUM_PLAYER  @"wins_medium_player"
#define WINS_EASY_PLAYER    @"wins_easy_player"

#define IS_IPHONE_5 ([UIScreen mainScreen].bounds.size.height == 568.0f)
#define IS_IPHONE_6 ([UIScreen mainScreen].bounds.size.height == 667.0f)
#define IS_IPHONE_6P ([UIScreen mainScreen].bounds.size.height == 736.0f)
#define IPHONE5_DIFF 88
#define BUTTON_TEXT_SIZE_IPAD 30
#define BUTTON_TEXT_SIZE_IPHONE 16

#define MIN_LAST_TIME 14400
#define MIN_POST_TIME 86400
#define STARS_FROM_TIME 1800
#define NOTOFICATION_TIME 14400
#define STARS_FOR_POST 5
#define STARS_FOR_INVITE 45

CG_INLINE NSString *deviceType()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
		return IPAD;
	else
		return IPHONE;
#else
	return IPHONE;
#endif
}

CG_INLINE NSString *imagePrefix() {
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        return @"_iPad";
    } else if (IS_IPHONE_5) {
        return @"_568h";
    } else if (IS_IPHONE_6) {
        return @"_667h";
    } else if (IS_IPHONE_6P) {
        return @"_736h";
    } else {
        return @"";
    }
}

#endif
