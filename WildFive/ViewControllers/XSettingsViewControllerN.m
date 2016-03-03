//
//  XSettingsViewControllerN.m
//  WildFive
//
//  Created by Lion User on 06/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XSettingsViewControllerN.h"
#import "XSoundEngine.h"
#import "XSettingsViewSizeBackBoard.h"
#import "XSettingsViewSizeAboveBoard.h"
#import "XConfiguration.h"
#import "XSettingsMenu.h"
#import "XSettingsCellSize.h"
                                                                            
@interface XSettingsViewControllerN ()
@property (nonatomic, retain) IBOutlet UISlider *sliderBackMusic;
@property (nonatomic, retain) IBOutlet UISlider *sliderSoundEffect;
@property (nonatomic, retain) IBOutlet UISwitch *switchMusic;
@property (nonatomic, retain) IBOutlet UISwitch *switchVibration;
@property (nonatomic, retain) IBOutlet XSettingsViewSizeBackBoard *viewBackBoard;
@property (nonatomic, retain) IBOutlet UIView *viewGameSettings;
@property (nonatomic, retain) IBOutlet UIView *viewMusicSettings;
@property (nonatomic, retain) IBOutlet UIView *viewForAnnimation;

@property(nonatomic, retain) IBOutlet UILabel *mTextLabel;

- (void) backgroundMusicSliderDidChanged:(UISlider*)pSlider;
- (void) soundEffectSliderDidChanged:(UISlider*)pSlider;
- (void) switchEnableSoundChanged:(UISwitch*)pSwitch;
- (void) switchEnableVibroChanged:(UISwitch*)pSwitch;

- (void) changeSettingsViewOnGame;
- (void) changeSettingsViewOnMusic;

- (void) initialization;
@end

@implementation XSettingsViewControllerN
@synthesize sliderBackMusic=_sliderBackMusic;
@synthesize sliderSoundEffect=_sliderSoundEffect;
@synthesize switchMusic=_switchMusic;
@synthesize switchVibration=_switchVibration;

@synthesize viewBackBoard=_viewBackBoard;
@synthesize viewGameSettings=_viewGameSettings;
@synthesize viewMusicSettings=_viewMusicSettings;
@synthesize viewForAnnimation=_viewForAnnimation;

@synthesize mTextLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mConfiguration = [XConfiguration sharedConfiguration];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
    [_sliderBackMusic addTarget:self action:@selector(backgroundMusicSliderDidChanged:) forControlEvents:UIControlEventValueChanged];
    [_sliderSoundEffect addTarget:self action:@selector(soundEffectSliderDidChanged:) forControlEvents:UIControlEventValueChanged];
    [_switchMusic addTarget:self action:@selector(switchEnableSoundChanged:) forControlEvents:UIControlEventValueChanged];
    [_switchVibration addTarget:self action:@selector(switchEnableVibroChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_viewForAnnimation addSubview:_viewGameSettings];
    [_viewBackBoard createAboveView:[XConfiguration sharedConfiguration].boardSize];
    
    [mTextLabel setText:NSLocalizedString(@"Board Size:", @"SettingsVC")];
    [self initialization];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [mConfiguration setBoardSize:XBoardSizeMake(self.viewBackBoard.viewAboveBoard.frame.size.width/[XSettingsCellSize cellSize].width, self.viewBackBoard.viewAboveBoard.frame.size.height/[XSettingsCellSize cellSize].height)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (void) initialization {
    _sliderBackMusic.value = [mConfiguration musicValue];
    _sliderSoundEffect.value = [mConfiguration soundEffectValue];
    _switchMusic.on = [mConfiguration soundeEnable];
    _switchVibration.on = [mConfiguration vibrationEnable];
}
- (void) backgroundMusicSliderDidChanged:(UISlider*)pSlider {
    [[XSoundEngine sharedEngine] setValueForBackgroundMusic:pSlider.value];
    [mConfiguration setMusicValue:pSlider.value];
}
- (void) soundEffectSliderDidChanged:(UISlider*)pSlider {
    [mConfiguration setSoundValue:pSlider.value];
}

- (void) switchEnableSoundChanged:(UISwitch*)pSwitch {
    if (pSwitch.on) {        
        [_sliderBackMusic setValue:[mConfiguration musicValue]];
        [_sliderSoundEffect setValue:[mConfiguration soundEffectValue]]; 
        [[XSoundEngine sharedEngine] playSound:XSoundBackground];
        [[XSoundEngine sharedEngine] setValueForBackgroundMusic:_sliderBackMusic.value];
        
    }else if (!pSwitch.on) {
        [[XSoundEngine sharedEngine] stopSound:XSoundBackground];
        [_sliderBackMusic setValue:0.0f];
        [_sliderSoundEffect setValue:0.0f];
    }
    [mConfiguration setSoundEnable:pSwitch.on];
}
- (void) switchEnableVibroChanged:(UISwitch *)pSwitch {
    [mConfiguration setVibrationEnable:pSwitch.on];
}

- (void) changeSettingsViewOnGame {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:MENU_DURATION];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_viewForAnnimation cache:NO];
    [_viewForAnnimation addSubview:_viewGameSettings];
    [_viewMusicSettings removeFromSuperview];
    [UIView commitAnimations];
    [self setRightButtonTitle:@"Music"];
    
}

- (void) changeSettingsViewOnMusic {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:MENU_DURATION];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_viewForAnnimation cache:NO];
    [_viewForAnnimation addSubview:_viewMusicSettings];
    [_viewGameSettings removeFromSuperview];
    [UIView commitAnimations];
    [self setRightButtonTitle:@"Game"];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
    [_viewBackBoard touchesBegan:touches withEvent:event]; 
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_viewBackBoard touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_viewBackBoard touchesEnded:touches withEvent:event];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
