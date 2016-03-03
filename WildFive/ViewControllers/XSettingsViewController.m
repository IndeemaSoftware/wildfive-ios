//
//  XSettingsViewController.m
//  WildFive
//
//  Created by naceka on 12.02.12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XSettingsViewController.h"
#import "XSettingsViewSizeBackBoard.h"
#import "XSettingsViewSizeAboveBoard.h"
#import "XSettingsCellSize.h"
#import "XCommon.h"
#import "XConfiguration.h"
#import "XSoundEngine.h"
#import "XGameEnums.h"

#define LEFT_OFFSET 20.0f
#define DURATION_TITLE 0.4f

@interface XSettingsViewController()
- (void) handleNotificationActiveResize:(NSNotification*)pNotification;

- (void) backgroundMusicSliderDidChanged:(UISlider*)pSlider;
- (void) soundEffectSliderDidChanged:(UISlider*)pSlider;

- (void) switchEnableSoundChanged:(UISwitch*)pSwitch;


- (void) buttonTitleGameSettingsClick:(id)pSender;
- (void) buttonTitleMusicSettingsClick:(id)pSender;

- (void) openSettingsView:(XSettingsView)pView withSelector:(SEL)pSelector;
- (void) closeSettingsView:(XSettingsView)pView withSelector:(SEL)pSelector;

- (void) animationDidStopForOpenSettings;
- (void) animationDidStopForCloseSettings;

- (void) animationDidStopForChangeGameSettings;
- (void) animationDidStopForChangeMusicSettings;

//*****set view settings - MUSIC and GAMES
- (void) setGameSettings;
- (void) setMusicSettings;
//private properties
- (void) setEnabledForButtonTitle:(BOOL)pEnable;
@end

@implementation XSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationActiveResize:) name:ACTIVE_RESIZE object:nil];
    [mBackButton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    //**********************NEW SETTINGS********************//
    [self setGameSettings];
    [self setMusicSettings];    

    
    mButtonTitleGameSettings = [UIButton buttonWithType:UIButtonTypeCustom]; 
    mButtonTitleGameSettings.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
    [XCommon roundMyView:mButtonTitleGameSettings borderRadius:0.0f borderWidth:1.0f color:[UIColor blackColor]];
    mButtonTitleGameSettings.backgroundColor = [UIColor brownColor];
    [mButtonTitleGameSettings addTarget:self action:@selector(buttonTitleGameSettingsClick:) forControlEvents:UIControlEventTouchDown];    
    mLabelTitleGameSettings = [[UILabel alloc] init];
    mLabelTitleGameSettings.backgroundColor = [UIColor clearColor];
    mLabelTitleGameSettings.font = [UIFont boldSystemFontOfSize:15.0f];
    mLabelTitleGameSettings.text = NSLocalizedString(@"Game Settings",@"SettingsVC");
    mLabelTitleGameSettings.frame = CGRectMake(0, 0, [mLabelTitleGameSettings.text sizeWithFont:mLabelTitleGameSettings.font].width, [mLabelTitleGameSettings.text sizeWithFont:mLabelTitleGameSettings.font].height);    
    mLabelTitleGameSettings.center = mButtonTitleGameSettings.center;
    [mButtonTitleGameSettings addSubview:mLabelTitleGameSettings];    
    
    mButtonTitleMusicSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    mButtonTitleMusicSettings.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
    [mButtonTitleMusicSettings addTarget:self action:@selector(buttonTitleMusicSettingsClick:) forControlEvents:UIControlEventTouchDown];
    [XCommon roundMyView:mButtonTitleMusicSettings borderRadius:0.0f borderWidth:1.0f color:[UIColor blackColor]];
    mButtonTitleMusicSettings.backgroundColor = [UIColor brownColor];      
    
    mLabelTitleMusicSettings = [[UILabel alloc] init];
    mLabelTitleMusicSettings.backgroundColor = [UIColor clearColor];
    mLabelTitleMusicSettings.font = [UIFont boldSystemFontOfSize:15.0f];
    mLabelTitleMusicSettings.text = NSLocalizedString(@"Music Settings",@"SettingsVC");
    mLabelTitleMusicSettings.frame = CGRectMake(0, 0, [mLabelTitleMusicSettings.text sizeWithFont:mLabelTitleMusicSettings.font].width, [mLabelTitleMusicSettings.text sizeWithFont:mLabelTitleMusicSettings.font].height);    
    mLabelTitleMusicSettings.center = CGPointMake(mButtonTitleMusicSettings.frame.size.width/2, mButtonTitleMusicSettings.bounds.size.height/2);
    [mButtonTitleMusicSettings addSubview:mLabelTitleMusicSettings];
    
    [self.view addSubview:mButtonTitleGameSettings];
    [self.view addSubview:mButtonTitleMusicSettings];
    
    
    
    
}
#pragma mark - SetSettingsView
- (void) setGameSettings {
    mViewGameSettings = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mViewGameSettings.hidden = YES;
    [self.view addSubview:mViewGameSettings];
    [mViewGameSettings release];
    
    mLabelTitlePlayerName = [[UILabel alloc] init];
    mLabelTitlePlayerName.text = NSLocalizedString(@"Name:", @"SettingsVC");
    mLabelTitlePlayerName.font = [UIFont systemFontOfSize:14.0f];
    mLabelTitlePlayerName.frame = CGRectMake(LEFT_OFFSET, 75, [mLabelTitlePlayerName.text sizeWithFont:mLabelTitlePlayerName.font].width, [mLabelTitlePlayerName.text sizeWithFont:mLabelTitlePlayerName.font].height);
    mLabelTitlePlayerName.backgroundColor = [UIColor clearColor];
    
    mLabelTitleFieldSize = [[UILabel alloc] init];
    mLabelTitleFieldSize.text = NSLocalizedString(@"Field Size:", @"SettingsVC") ;
    mLabelTitleFieldSize.font = [UIFont systemFontOfSize:14.0f];
    mLabelTitleFieldSize.frame = CGRectMake(LEFT_OFFSET, 100, [mLabelTitleFieldSize.text sizeWithFont:mLabelTitleFieldSize.font].width, [mLabelTitleFieldSize.text sizeWithFont:mLabelTitleFieldSize.font].height);
    mLabelTitleFieldSize.backgroundColor = [UIColor clearColor];
    
    mViewBackBoard = [[XSettingsViewSizeBackBoard alloc] initWithFrame:CGRectMake(LEFT_OFFSET, 120, [XSettingsCellSize cellSize].width*CELL_COUNT_MAX, [XSettingsCellSize cellSize].height*CELL_COUNT_MAX)];
    [mViewBackBoard createAboveView:[XConfiguration sharedConfiguration].boardSize];
    
    mViewBackBoard.backgroundColor = [UIColor grayColor];
    
    [mViewGameSettings addSubview:mLabelTitlePlayerName];
    [mViewGameSettings addSubview:mLabelTitleFieldSize];
    [mViewGameSettings addSubview:mViewBackBoard];
    
    [mLabelTitlePlayerName release];
    [mLabelTitleFieldSize release];
    [mViewBackBoard release];   
    
}
- (void) setMusicSettings {
    
    mViewMusicSettings = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mViewMusicSettings.hidden = YES;    
    [self.view addSubview:mViewMusicSettings];
    [mViewMusicSettings release];
    
    mLabelTitleBackgroundMusic = [[UILabel alloc] init];
    mLabelTitleBackgroundMusic.text =NSLocalizedString(@"Background Music:", @"SettingsVC");
    mLabelTitleBackgroundMusic.font = [UIFont systemFontOfSize:14.0f];
    [mLabelTitleBackgroundMusic setBackgroundColor:[UIColor clearColor]];
    mLabelTitleBackgroundMusic.frame = CGRectMake(LEFT_OFFSET, 65, [mLabelTitleBackgroundMusic.text sizeWithFont:mLabelTitleBackgroundMusic.font].width, [mLabelTitleBackgroundMusic.text sizeWithFont:mLabelTitleBackgroundMusic.font].height);
    
    mSliderBackgroundMusic = [[UISlider alloc] initWithFrame:CGRectMake(40, 90, 240, 20)];
    mSliderBackgroundMusic.value = [[XConfiguration sharedConfiguration] musicValue];
    [mSliderBackgroundMusic addTarget:self action:@selector(backgroundMusicSliderDidChanged:) forControlEvents:UIControlEventValueChanged];

    
    mLabelTitleSoundEffect = [[UILabel alloc] init];
    mLabelTitleSoundEffect.text =NSLocalizedString(@"Sound Effect:",@"SettingsVC");
    mLabelTitleSoundEffect.font = [UIFont systemFontOfSize:14.0f];
    [mLabelTitleSoundEffect setBackgroundColor:[UIColor clearColor]];
    mLabelTitleSoundEffect.frame = CGRectMake(LEFT_OFFSET, 125, [mLabelTitleSoundEffect.text sizeWithFont:mLabelTitleSoundEffect.font].width, [mLabelTitleSoundEffect.text sizeWithFont:mLabelTitleSoundEffect.font].height);
    
    mSliderSoundEffect = [[UISlider alloc] initWithFrame:CGRectMake(40, 150, 240, 20)];  
    mSliderSoundEffect.value = [[XConfiguration sharedConfiguration] soundEffectValue];
    [mSliderSoundEffect addTarget:self action:@selector(soundEffectSliderDidChanged:) forControlEvents:UIControlEventValueChanged];

    
    mLabelTitleEnableSound = [[UILabel alloc] init];
    mLabelTitleEnableSound.text = NSLocalizedString(@"Enable Sound:",@"SettingsVC");
    mLabelTitleEnableSound.font = [UIFont systemFontOfSize:14.0f];
    [mLabelTitleEnableSound setBackgroundColor:[UIColor clearColor]];
    mLabelTitleEnableSound.frame = CGRectMake(LEFT_OFFSET, 195, [mLabelTitleEnableSound.text sizeWithFont:mLabelTitleEnableSound.font].width, [mLabelTitleEnableSound.text sizeWithFont:mLabelTitleEnableSound.font].height); 
    
    mSwitchEnableSound = [[UISwitch alloc] initWithFrame:CGRectMake(185, 190, 100, 30)];
    [mSwitchEnableSound addTarget:self action:@selector(switchEnableSoundChanged:) forControlEvents:UIControlEventValueChanged];
    [mSwitchEnableSound setOn:[[XConfiguration sharedConfiguration] soundeEnable]];
    
    mLabelTitleVibratingTone = [[UILabel alloc] init];
    mLabelTitleVibratingTone.text = NSLocalizedString(@"Vibration Tone:",@"SettingsVC");
    mLabelTitleVibratingTone.font = [UIFont systemFontOfSize:14.0f];
    [mLabelTitleVibratingTone setBackgroundColor:[UIColor clearColor]];
    mLabelTitleVibratingTone.frame = CGRectMake(LEFT_OFFSET, 235, [mLabelTitleVibratingTone.text sizeWithFont:mLabelTitleVibratingTone.font].width, [mLabelTitleVibratingTone.text sizeWithFont:mLabelTitleVibratingTone.font].height);  
    
    mSwitchVibration = [[UISwitch alloc] initWithFrame:CGRectMake(185, 230, 100, 30)];
    [mSwitchVibration setOn:[[XConfiguration sharedConfiguration] vibrationEnable]];
    
    [mViewMusicSettings addSubview:mLabelTitleBackgroundMusic];
    [mViewMusicSettings addSubview:mSliderBackgroundMusic];
    [mViewMusicSettings addSubview:mLabelTitleSoundEffect];
    [mViewMusicSettings addSubview:mSliderSoundEffect];
    [mViewMusicSettings addSubview:mLabelTitleEnableSound];
    [mViewMusicSettings addSubview:mSwitchEnableSound];
    [mViewMusicSettings addSubview:mLabelTitleVibratingTone];
    [mViewMusicSettings addSubview:mSwitchVibration];
    
    [mLabelTitleBackgroundMusic release];
    [mSliderBackgroundMusic release];
    [mLabelTitleSoundEffect release];
    [mSliderSoundEffect release];
    [mLabelTitleEnableSound release];
    [mSwitchEnableSound release];
    [mLabelTitleVibratingTone release];
    [mSwitchVibration release];    
    
}
#pragma mark -
#pragma mark - StartSettings Methods
- (void) buttonTitleGameSettingsClick:(id)pSender {
    [self setEnabledForButtonTitle:NO];
    
    if ((mViewGameSettings.hidden == YES) && (mViewMusicSettings.hidden == YES)) {
        
        [self openSettingsView:XSettingsViewGame withSelector:@selector(animationDidStopForOpenSettings)];
        
    } else if ((mViewGameSettings.hidden == NO) && (mViewMusicSettings.hidden == YES)) {
        
        [self closeSettingsView:XSettingsViewGame withSelector:@selector(animationDidStopForCloseSettings)];
    } else if ((mViewGameSettings.hidden == YES)&&(mViewMusicSettings.hidden == NO)) {
        [self closeSettingsView:XSettingsViewMusic withSelector:@selector(animationDidStopForChangeGameSettings)];
    }
    
    
}
- (void) buttonTitleMusicSettingsClick:(id)pSender {
    [self setEnabledForButtonTitle:NO];
    
    if ((mViewMusicSettings.hidden == YES)&&(mViewGameSettings.hidden == YES)) {
        
        [self openSettingsView:XSettingsViewMusic withSelector:@selector(animationDidStopForOpenSettings)];
        
    } else if ((mViewMusicSettings.hidden == NO)&&(mViewGameSettings.hidden == YES)) {
        
        [self closeSettingsView:XSettingsViewMusic withSelector:@selector(animationDidStopForCloseSettings)];        
        
    } else if ((mViewMusicSettings.hidden == YES)&&(mViewGameSettings.hidden == NO)) {
        
        [self closeSettingsView:XSettingsViewGame withSelector:@selector(animationDidStopForChangeMusicSettings)];
    }
    
}
- (void) openSettingsView:(XSettingsView)pView withSelector:(SEL)pSelector {
    switch (pView) {
        case XSettingsViewGame:
            mViewGameSettings.hidden = NO;
            mViewMusicSettings.hidden = YES;
            break;
        case XSettingsViewMusic:
            mViewGameSettings.hidden = YES;
            mViewMusicSettings.hidden = NO;
            
        default:
            break;
    }
    CGFloat lYGameOpen = -178.0f;
    CGFloat lYMusicOpen = 396.0f;
    [XCommon setAnimationForView:mButtonTitleGameSettings setDuration:DURATION_TITLE setFrame:CGRectMake(0, lYGameOpen, mButtonTitleGameSettings.frame.size.width, mButtonTitleGameSettings.frame.size.height) setDelegate:self setSelectorAfterAnimation:pSelector];
    
    [XCommon setAnimationForView:mButtonTitleMusicSettings setDuration:DURATION_TITLE setFrame:CGRectMake(0, lYMusicOpen, mButtonTitleMusicSettings.frame.size.width, mButtonTitleMusicSettings.frame.size.height)];
    
    
    [XCommon setAnimationForView:mLabelTitleGameSettings setDuration:DURATION_TITLE setFrame:CGRectMake(mLabelTitleGameSettings.frame.origin.x, mButtonTitleGameSettings.frame.size.height-mLabelTitleGameSettings.frame.size.height-5, mLabelTitleGameSettings.frame.size.width, mLabelTitleGameSettings.frame.size.height)];
    
    [XCommon setAnimationForView:mLabelTitleMusicSettings setDuration:DURATION_TITLE setFrame:CGRectMake(mLabelTitleMusicSettings.frame.origin.x, mButtonTitleMusicSettings.bounds.origin.y+5, mLabelTitleMusicSettings.frame.size.width, mLabelTitleMusicSettings.frame.size.height)];
    
}
- (void) closeSettingsView:(XSettingsView)pView withSelector:(SEL)pSelector {
    
    [XCommon setAnimationForView:mButtonTitleGameSettings setDuration:DURATION_TITLE setFrame:CGRectMake(0, 0, mButtonTitleGameSettings.frame.size.width, mButtonTitleGameSettings.frame.size.height) setDelegate:self setSelectorAfterAnimation:pSelector];
    
    [XCommon setAnimationForView:mButtonTitleMusicSettings setDuration:DURATION_TITLE setFrame:CGRectMake(0, self.view.frame.size.height/2, mButtonTitleMusicSettings.frame.size.width, mButtonTitleMusicSettings.frame.size.height)];
    
    [XCommon setAnimationForView:mLabelTitleGameSettings setDuration:DURATION_TITLE setCenter:CGPointMake(mLabelTitleGameSettings.center.x, mButtonTitleGameSettings.frame.size.height/2)];
    
    [XCommon setAnimationForView:mLabelTitleMusicSettings setDuration:DURATION_TITLE setCenter:CGPointMake(mLabelTitleMusicSettings.center.x, mButtonTitleMusicSettings.bounds.size.height/2)];
    
    
}
- (void) animationDidStopForOpenSettings {
    
    [self setEnabledForButtonTitle:YES];
    
}
- (void) animationDidStopForCloseSettings {
    
    [self setEnabledForButtonTitle:YES];
    mViewGameSettings.hidden = YES;
    mViewMusicSettings.hidden = YES;    
}
- (void) animationDidStopForChangeGameSettings {
    
    [self openSettingsView:XSettingsViewGame withSelector:@selector(animationDidStopForOpenSettings)];
    
}
- (void) animationDidStopForChangeMusicSettings {
    
    [self openSettingsView:XSettingsViewMusic withSelector:@selector(animationDidStopForOpenSettings)];
}
- (void) setEnabledForButtonTitle:(BOOL)pEnable {
    mButtonTitleGameSettings.enabled = pEnable;
    mButtonTitleMusicSettings.enabled = pEnable;
}
#pragma mark -

- (void) handleNotificationActiveResize:(NSNotification *)pNotification {
    if ([[pNotification object] intValue] == 1) {
        [mScrollView setScrollEnabled:NO];
    }else if([[pNotification object] intValue] == 0) {
        [mScrollView setScrollEnabled:YES];
    }   
}
- (void) saveSettings {
    [[XConfiguration sharedConfiguration] setBoardSize:XBoardSizeMake(mViewBackBoard.viewAboveBoard.frame.size.width/[XSettingsCellSize cellSize].width, mViewBackBoard.viewAboveBoard.frame.size.height/[XSettingsCellSize cellSize].height)];
    [[XConfiguration sharedConfiguration] setMusicValue:mSliderBackgroundMusic.value];
    [[XConfiguration sharedConfiguration] setSoundValue:mSliderSoundEffect.value];
    [[XConfiguration sharedConfiguration] setSoundEnable:mSwitchEnableSound.on];
    [[XConfiguration sharedConfiguration] setVibrationEnable:mSwitchVibration.on];
}
- (void) backgroundMusicSliderDidChanged:(UISlider*)pSlider {
    [[XSoundEngine sharedEngine] setValueForBackgroundMusic:pSlider.value];

}
- (void) soundEffectSliderDidChanged:(UISlider *)pSlider {
    
    
}
- (void) switchEnableSoundChanged:(UISwitch *)pSwitch {
    if (pSwitch.on) {

        [mSliderBackgroundMusic setValue:0.5f];
        [mSliderSoundEffect setValue:0.5f]; 
        [[XSoundEngine sharedEngine] playSound:XSoundBackground];
        [[XSoundEngine sharedEngine] setValueForBackgroundMusic:mSliderBackgroundMusic.value];
        
    }else if (!pSwitch.on) {
        [[XSoundEngine sharedEngine] stopSound:XSoundBackground];
        [mSliderBackgroundMusic setValue:0.0f];
        [mSliderSoundEffect setValue:0.0f];
    }

    
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self saveSettings];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [mViewBackBoard touchesBegan:touches withEvent:event];
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [mViewBackBoard touchesMoved:touches withEvent:event];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [mViewBackBoard touchesEnded:touches withEvent:event];
}

- (void)rightNavigationButtonPressed:(id)pSender {
    [self buttonTitleMusicSettingsClick:pSender];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVE_RESIZE object:nil];
    [mBackgroundImageView release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showRightButton];
    [self showBackButton];
}

@end
