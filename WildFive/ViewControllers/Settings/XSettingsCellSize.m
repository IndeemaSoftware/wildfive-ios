//
//  XSettingsCellSize.m
//  WildFive
//
//  Created by naceka on 22.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XSettingsCellSize.h"


@implementation XSettingsCellSize
+ (CGSize) cellSize {
    CGSize lCellSize;
    if([deviceType() isEqualToString:IPHONE]){
        lCellSize = CGSizeMake(14, 14);
    }else if([deviceType() isEqualToString:IPAD]){
        lCellSize = CGSizeMake(30, 30);
    }
    return lCellSize;
}

@end
