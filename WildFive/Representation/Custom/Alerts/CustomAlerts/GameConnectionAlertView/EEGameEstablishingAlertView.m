//
//  EEGameConnectionAlertView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/15/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEGameEstablishingAlertView.h"
#import "EEAlertView_hidden.h"

@interface EEGameEstablishingAlertView() {
    IBOutlet UILabel *_messageLabel;
    
    IBOutlet UIButton *_declineButton;
    IBOutlet UIButton *_acceptButton;
}

- (void)updateAlertAccordingToState;

@end

@implementation EEGameEstablishingAlertView

#pragma mark - Public methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _state = EEGameEstablishingInitial;
    _type = EEGameEstablishingAlertViewTypeInviting;
}

- (void)setState:(EEGameEstablishingState)state {
    _state = state;
    [self updateAlertAccordingToState];
}

- (void)setInvitationName:(NSString *)invitatorName {
    _invitationName = [invitatorName copy];
    [self updateAlertAccordingToState];
}

#pragma mark - Private methods
- (void)updateAlertAccordingToState {
    NSString *lMessageString = _messageLabel.text;
    
    if (self.state == EEGameEstablishingInitial) {
        if (self.type == EEGameEstablishingAlertViewTypeInviting) {
            lMessageString = [NSString stringWithFormat:NSLocalizedString(@"Sending invitation to %@", nil), _invitationName];
            [_acceptButton setHidden:YES];
        } else {
            lMessageString = [NSString stringWithFormat:NSLocalizedString(@"You are invited by %@", nil), _invitationName];
        }
    } else if (_state == EEGameEstablishingConnecting) {
        lMessageString = @"Connecting";
        
        [_declineButton setHidden:YES];
        [_acceptButton setHidden:YES];
    } else if (_state == EEGameEstablishingConnected) {
        lMessageString = @"Connected";
        
        [_declineButton setHidden:YES];
        [_acceptButton setHidden:YES];
    } else if (_state == EEGameEstablishingConnectionFailed) {
        lMessageString = @"Connection faild";
        
        [_declineButton setHidden:YES];
        [_acceptButton setHidden:YES];
    }
    
    [_messageLabel setText:lMessageString];
}

@end
