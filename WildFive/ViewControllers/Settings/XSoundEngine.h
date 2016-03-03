//
//  XSoundEngine.h
//  WildFive
//
//  Created by naceka on 26.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
typedef enum {
    XSoundBackground = 0,
    XSoundButtonClick = 1,
    XSoundFixElement = 2,
    XSoundPutElement = 3,
    XSoundChangeElementPosition = 4,
} XSound;

@interface XSoundEngine : NSObject {
    AVAudioPlayer *mAudioPlayer;
    
}
+ (XSoundEngine*) sharedEngine;
- (void) playSound:(XSound)pSound;
- (void) stopSound:(XSound)pSound;
- (void) playSoundButtonClick;
- (void) playSoundFixElement;
- (void) playSoundPutElement;
- (void) playSoundChangeElementPosition;
- (void) playSoundWonGame;
- (void) playSoundLoseGame;
- (void) playSoundStartGame;
- (void) setValueForBackgroundMusic:(CGFloat)pValue;

@end
