//
//  EEFlowViewController_hidden.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFlowViewController.h"
#import "EEAbstractViewController_hidden.h"

@interface EEFlowViewController () {
    IBOutlet UIImageView *_backgroundImageView;
}

- (NSUInteger)flowIndex;

@end
