//
//  EEGameConnection.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/13/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEEsteblishedConnection.h"

@protocol EEGameConnectionDelegate;

@protocol EEGameConnection <NSObject>

@property (nonatomic, readonly) NSString *playerType;
@property (nonatomic, readonly) NSString *playerName;
@property (nonatomic, assign) EEGameConnectionType connectionType;

@property (nonatomic, weak) id <EEGameConnectionDelegate> delegate;

- (instancetype)initWithConnection:(EEEsteblishedConnection *)connection;
+ (instancetype)gameConnectionWith:(EEEsteblishedConnection *)connection;

- (void)sendMessage:(NSData *)message;

@end
