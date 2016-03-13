//
//  EEEsteblishedConnection.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/13/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface EEEsteblishedConnection : NSObject

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, copy) NSString *playerType;
@property (nonatomic, copy) NSString *playerName;

@end
