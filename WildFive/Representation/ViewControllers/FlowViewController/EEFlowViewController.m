//
//  EEFlowViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEFlowViewController.h"
#import "EEFlowViewController_hidden.h"

@implementation EEFlowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // update background image view
    [_backgroundImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"background_screen_%i%@.png", [self flowIndex], imagePrefix()]]];
}

#pragma mark - Private methods
- (NSUInteger)flowIndex {
    return 0;
}

@end
