//
//  EEBoardViewItem.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEGameCommon.h"

@interface EEBoardViewItem : UICollectionViewCell

@property (nonatomic, assign) EEBoardSign boardSign;
@property (nonatomic, copy) NSString *title;

+ (NSString*)reuseIdentifier;

@end
