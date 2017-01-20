//
//  EEListOfGamesViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFlowViewController.h"

typedef NS_ENUM(NSInteger, EEListType) {
    EEListTypeLocal,
    EEListTypeOnline
};

@interface EEListOfGamesViewController : EEFlowViewController

@property (nonatomic, readonly) EEListType listType;

- (instancetype)initWithListType:(EEListType)listType;

@end
