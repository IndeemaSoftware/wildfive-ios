//
//  XConfiguration.h
//  WildFive
//
//  Created by naceka on 24.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGameEnums.h"

#define S_PLAYER_NAME               @"PlayerName"
#define S_BOARD_SIZE                @"BoardSize"
#define S_BACKGROUND_MUSIC_VOLUME   @"BackgroundMusicVolume"
#define S_SOUND_EFFECT_VOLUME       @"SoundEffectVolume"
#define S_VIBRATION                 @"Vibration"
#define S_FIRST_START_KEY           @"FirstStartKey"
#define S_SOUNDE_ENABLE             @"SoundeEnable"



@interface XConfiguration : NSObject {
    
}
+ (XConfiguration*) sharedConfiguration;
- (NSString*) playerName;
- (void) setPlayerName:(NSString*)pPlayerName;
//*******CELL_NUMBER = BOARD_SIZE / XSETTING_CELL_SIZE********//
- (XBoardSize) boardSize;
- (void) setBoardSize:(XBoardSize)pBoardSize;

- (void) setMusicValue:(CGFloat)pValue; 
- (void) setSoundValue:(CGFloat)pValue;
- (CGFloat) musicValue;
- (CGFloat) soundEffectValue;
- (void) setSoundEnable:(BOOL)pEnable;
- (BOOL) soundeEnable;
- (void) setVibrationEnable:(BOOL)pEnable;
- (BOOL) vibrationEnable;
- (void) setDefaultSettings;

@end
