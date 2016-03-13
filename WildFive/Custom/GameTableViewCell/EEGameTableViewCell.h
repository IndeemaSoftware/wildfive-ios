//
//  EEGameTableViewCell.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/12/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEGameCommon.h"

static NSString *sGameTableViewCellId = @"EEGameTableViewCellId";

@interface EEGameTableViewCell : UITableViewCell

@property (nonatomic, assign) EEPlayerType playerType;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, assign, setter=setLocked:) BOOL isLocked;



@end
