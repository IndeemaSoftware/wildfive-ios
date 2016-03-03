
//  XConfiguration.m
//  WildFive
//
//  Created by naceka on 24.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "XConfiguration.h"
#import "XSettingsCellSize.h"

#define DEFAULT_VOLUME_VALUE 0.5f
#define S_BOARD_SIZE_WIDTH @"boardsizewidth"
#define S_BOARD_SIZE_HEIGHT @"boardsizeheight"
@implementation XConfiguration

static XConfiguration *configuration = nil;

+ (XConfiguration*) sharedConfiguration {    
	if(configuration == nil)
    {
		configuration = [[XConfiguration alloc] init];
    }
    return configuration;
}
- (NSString*) playerName {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:S_PLAYER_NAME] == nil) {
        return @"";
    } 
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_PLAYER_NAME];    
}
- (void) setPlayerName:(NSString*)pPlayerName {
    [[NSUserDefaults standardUserDefaults] setObject:pPlayerName forKey:S_PLAYER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (XBoardSize) boardSize {    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:S_BOARD_SIZE] == nil) {
//        if([deviceType() isEqualToString:IPHONE]){
//            return XBoardSizeMake(5, 5);
//        } else if([deviceType() isEqualToString:IPAD]){
//            return XBoardSizeMake(5, 5);
//        }
//    }
//    NSDictionary *lDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:S_BOARD_SIZE]];
//    
    XBoardSize lBoardSize = XBoardSizeMake(19, 19);
    return lBoardSize;    
}
- (void) setBoardSize:(XBoardSize)pBoardSize {    
    NSDictionary *lDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:pBoardSize.width],S_BOARD_SIZE_WIDTH,[NSNumber numberWithUnsignedInt:pBoardSize.height],S_BOARD_SIZE_HEIGHT, nil];
    NSData *lData = [NSKeyedArchiver archivedDataWithRootObject:lDictionary];
    [lDictionary release];
    
    [[NSUserDefaults standardUserDefaults] setObject:lData forKey:S_BOARD_SIZE];        
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void) setMusicValue:(CGFloat)pValue {
    [[NSUserDefaults standardUserDefaults] setFloat:pValue forKey:S_BACKGROUND_MUSIC_VOLUME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void) setSoundValue:(CGFloat)pValue {
    [[NSUserDefaults standardUserDefaults] setFloat:pValue forKey:S_SOUND_EFFECT_VOLUME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (CGFloat) musicValue {         
    return [[NSUserDefaults standardUserDefaults] floatForKey:S_BACKGROUND_MUSIC_VOLUME];
}
- (CGFloat) soundEffectValue {
    return [[NSUserDefaults standardUserDefaults] floatForKey:S_SOUND_EFFECT_VOLUME];
}
- (void) setVibrationEnable:(BOOL)pEnable {
    [[NSUserDefaults standardUserDefaults] setBool:pEnable forKey:S_VIBRATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL) vibrationEnable {    
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_VIBRATION];   
}
- (void) setSoundEnable:(BOOL)pEnable {
    [[NSUserDefaults standardUserDefaults] setBool:pEnable forKey:S_SOUNDE_ENABLE];
    [[NSUserDefaults standardUserDefaults] synchronize];   
}
- (BOOL) soundeEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_SOUNDE_ENABLE];  
}

- (void) setDefaultSettings {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Player" forKey:S_PLAYER_NAME];
    //*****BOARD SIZE******//
    [[XConfiguration sharedConfiguration] setBoardSize:XBoardSizeMake(CELL_COUNT_MAX, CELL_COUNT_MAX)];
    
    [[NSUserDefaults standardUserDefaults] setFloat:DEFAULT_VOLUME_VALUE forKey:S_BACKGROUND_MUSIC_VOLUME];
    
    [[NSUserDefaults standardUserDefaults] setFloat:DEFAULT_VOLUME_VALUE forKey:S_SOUND_EFFECT_VOLUME];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:S_VIBRATION];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:S_SOUNDE_ENABLE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
