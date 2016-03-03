//
//  XSoundEngine.m
//  WildFive
//
//  Created by naceka on 26.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XSoundEngine.h"
#import "XConfiguration.h"
@interface XSoundEngine()
- (void) playBackgroundMusic;
- (void) stopBackgroundMusic;
@end
@implementation XSoundEngine
static XSoundEngine *soundEngine = nil;

+ (XSoundEngine*)sharedEngine {
    if (nil == soundEngine) {
        soundEngine = [[XSoundEngine alloc] init];
    }
    return soundEngine;
}
- (id) init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
- (void) playBackgroundMusic {
    return;
    NSString *lFilePath = [[NSBundle mainBundle] pathForResource:@"oltremare" ofType:@"mp3"];
    NSURL *lURL = [[NSURL alloc] initFileURLWithPath:lFilePath];
    mAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:lURL error:nil];
    [mAudioPlayer play]; 
    [mAudioPlayer setNumberOfLoops: -1];
    mAudioPlayer.volume = [[XConfiguration sharedConfiguration] musicValue];

}

- (void) playSoundButtonClick {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/button_click.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) playSoundFixElement {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/fix_element.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) playSoundPutElement {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/put_element.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) playSoundChangeElementPosition {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/change_element_position.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) playSoundWonGame {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/won_game.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) playSoundLoseGame {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/lose_game.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) playSoundStartGame {
    return;
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/start_game.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) stopBackgroundMusic {
    [mAudioPlayer stop];
}
- (void) playSound:(XSound)pSound {
    return;
    switch (pSound) {
        case XSoundBackground: {
            [self playBackgroundMusic];
            break;
        }
        case XSoundButtonClick: {
            [self playSoundButtonClick];
            break;
        }
        case XSoundFixElement: {
            [self playSoundFixElement];
            break;
        }
        case XSoundPutElement: {
            [self playSoundPutElement];
            break;
        }
        case XSoundChangeElementPosition: {
            [self playSoundChangeElementPosition];
            break;
        }
        default:
            break;
    }
    
}
- (void) stopSound:(XSound)pSound {
    switch (pSound) {
        case XSoundBackground:
            [self stopBackgroundMusic];
            break;
            
        default:
            break;
    }
    
}
- (void) setValueForBackgroundMusic:(CGFloat)pValue {
    mAudioPlayer.volume = pValue;
}
@end
