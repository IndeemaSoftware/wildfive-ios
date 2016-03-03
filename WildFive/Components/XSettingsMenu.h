//
//  XSettingsMenu.h
//  WildFive
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    XSettingsMenuChoiceGame=0,
    XSettingsMenuChoiceMusic
}XSettingsMenuChoice;

#define MENU_DURATION 0.7f

@interface XSettingsMenu : UIView {
    UIImageView *mImgBgrView;
    UILabel  *mLblTitle;
    NSInteger state;
    BOOL lock;
}
@property(nonatomic, retain) UILabel *lblTitle;
@property(nonatomic, copy) void (^changeViewOnGame)();
@property(nonatomic, copy) void (^changeViewOnMusic)();


@end
