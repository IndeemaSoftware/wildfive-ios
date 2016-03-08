//
//  EEPlayer.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/8/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEGameCommon.h"

@interface EEPlayer : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) EEPlayerType type;

@end
