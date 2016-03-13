//
//  EEEsteblishedConnection.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/13/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EEGameConnectionType) {
    EEGameConnectionTypeLocal,
    EEGameConnectionTypeGameCenter
};

@interface EEEsteblishedConnection : NSObject

@property (nonatomic, strong) id connectionObject;
@property (nonatomic, copy) NSString *playerType;
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, assign) EEGameConnectionType connectionType;

@end
