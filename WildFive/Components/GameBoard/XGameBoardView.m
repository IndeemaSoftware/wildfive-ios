//
//  XGameBoardView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/12/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XGameBoardView.h"
#import "XGameBoardCell.h"

@implementation XGameBoardView

#pragma mark - Initialization -
- (id) initWithFrame:(CGRect)pFrame withBoardSize:(XBoardSize) pBoardSize {
    self = [super initWithFrame:pFrame];
    
    if (self) {
        
        mBoardSize = pBoardSize;
        //[self drawPlayingField];
        self.multipleTouchEnabled = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        


    }
    
    return self;
}

#pragma mark - Drawing -

- (void) drawPlayingField{
    [super drawRect:mRect];
    [[UIColor redColor] set];
    UIBezierPath *lGridPathes = [UIBezierPath bezierPathWithRect:mRect];
    [lGridPathes setLineWidth:1.0f];
    //vertical lines
    for (int i=1;i<=mBoardSize.width;i++){
        [lGridPathes moveToPoint:CGPointMake(i * [XGameBoardCell cellSize].width, 0)];
        [lGridPathes addLineToPoint:CGPointMake((i * [XGameBoardCell cellSize].width) + 1.0, mRect.size.height)];
    }
    //horizontal lines
    for (int i=1;i<=mBoardSize.height;i++){
        [lGridPathes moveToPoint:CGPointMake(0, (i * [XGameBoardCell cellSize].width) + 1.0)];
        [lGridPathes addLineToPoint:CGPointMake(mRect.size.width,(i * [XGameBoardCell cellSize].width) + 1.0)];
    }
    [lGridPathes stroke];
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    DLog(@"===XGameViewBoard=== %@",NSStringFromCGRect(rect));
    mRect = rect;
    [self drawPlayingField];
}










    //Lines drawing

//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(currentContext);
//    CGContextSetRGBFillColor(currentContext, 0.0f, 0.0f, 0.0f, 0.0f);
//    CGContextSetLineWidth(currentContext, 1);
//    CGContextSetRGBStrokeColor(currentContext, 1.0f, 0.0f, 0.0f, 1.0f);
//    CGContextBeginPath(currentContext);
//    
//    //vertical lines
//    for (int i=0;i<=mBoardSize.width;i++){
//        CGContextMoveToPoint(currentContext, (i * [XGameBoardCell cellSize].width), 0);
//        CGContextAddLineToPoint(currentContext, (i * [XGameBoardCell cellSize].width) + 1.0, rect.size.height);
//    }
//    CGContextMoveToPoint(currentContext, self.frame.size.width-1, 0);
//    CGContextAddLineToPoint(currentContext, self.frame.size.width-1, self.frame.size.height-1);
//    //horizontal lines
//    for (int i=0;i<=mBoardSize.height;i++){
//        CGContextMoveToPoint(currentContext, 0, (i * [XGameBoardCell cellSize].width) + 1.0);
//        CGContextAddLineToPoint(currentContext, rect.size.width,(i * [XGameBoardCell cellSize].width) + 1.0);
//    }
//    CGContextMoveToPoint(currentContext, 0, self.frame.size.height-1);
//    CGContextAddLineToPoint(currentContext, self.frame.size.width-1, self.frame.size.height-1);
//    
//    CGContextStrokePath(currentContext);
//    CGContextRestoreGState(currentContext);


@end
