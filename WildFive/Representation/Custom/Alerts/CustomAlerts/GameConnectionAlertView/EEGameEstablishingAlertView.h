//
//  EEGameConnectionAlertView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/15/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEAlertView.h"

typedef NS_ENUM(NSInteger, EEGameEstablishingState) {
    EEGameEstablishingInitial = 0,
    EEGameEstablishingConnecting,
    EEGameEstablishingConnected,
    EEGameEstablishingConnectionFailed
};

typedef NS_ENUM(NSInteger, EEGameEstablishingAlertViewType) {
    EEGameEstablishingAlertViewTypeInviting = 0,
    EEGameEstablishingAlertViewTypeReceivingInvite
};

@interface EEGameEstablishingAlertView : EEAlertView

@property (nonatomic, assign) EEGameEstablishingState state;
@property (nonatomic, assign) EEGameEstablishingAlertViewType type;

@property (nonatomic, nonnull, copy) NSString *invitationName;
@property(nonatomic, nullable, copy) void(^invitationHandler)(BOOL accepted);

@end
