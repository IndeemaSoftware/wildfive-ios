//
//  XGameEnums.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XGameEnums.h"


XBoardSize XBoardSizeMake(NSUInteger pWidth, NSUInteger pHeight) {
    XBoardSize lBoardSize;
    lBoardSize.width = pWidth;
    lBoardSize.height = pHeight;
    return lBoardSize;
}

XBoardPoint XBoardPointMake(NSInteger pX, NSInteger pY) {
    XBoardPoint lBoardPoint;
    lBoardPoint.x = pX;
    lBoardPoint.y = pY;
    
    return lBoardPoint;
}