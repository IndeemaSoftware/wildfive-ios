//
//  XDemonstrationPlayingView.m
//  WildFive
//
//  Created by Admin on 08/12/2012.
//
//

#import "XDemonstrationPlayingView.h"
#import "XGameBoardCell.h"
@implementation XDemonstrationPlayingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.7f];
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{

    [[UIColor redColor] set];
    UIBezierPath *lGridPathes = [UIBezierPath bezierPathWithRect:rect];
    CGFloat lOffsetX = 0; //44;
    CGFloat lOffsetY = 0; //20;
    [lGridPathes setLineWidth:1.0f];
    //vertical lines
    for (int i=1;i<=13;i++){
        [lGridPathes moveToPoint:CGPointMake(i * [XGameBoardCell cellSize].width+lOffsetX, lOffsetY)];
        [lGridPathes addLineToPoint:CGPointMake((i * [XGameBoardCell cellSize].width) + 1.0+lOffsetX, rect.size.height+lOffsetY)];
    }
    //horizontal lines
    for (int i=1;i<=13;i++){
        [lGridPathes moveToPoint:CGPointMake(lOffsetX, (i * [XGameBoardCell cellSize].width) + 1.0+lOffsetY)];
        [lGridPathes addLineToPoint:CGPointMake(rect.size.width+lOffsetX,(i * [XGameBoardCell cellSize].width) + 1.0+lOffsetY)];
    }
    [lGridPathes stroke];
}

@end
