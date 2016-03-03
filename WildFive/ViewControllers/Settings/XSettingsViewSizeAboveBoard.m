//
//  XViewSizeSettingsAboveBoard.m
//  WildFive
//
//  Created by naceka on 21.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XSettingsViewSizeAboveBoard.h"
#import "XSettingsCellSize.h"
#import <QuartzCore/QuartzCore.h>
#import "XCommon.h"

@interface XSettingsViewSizeAboveBoard()
- (void) animationForArrow;
- (void) animationArrowStart;
- (void) animationArrowStop;

@end
@implementation XSettingsViewSizeAboveBoard
@synthesize displaySize;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        
        
    }
    return self;
}
- (void) initData {
    mLabelCircle = [[UILabel alloc] init];
    UIImage *lImage = [UIImage imageNamed:@"circle.png"];
    mLabelCircle.backgroundColor = [UIColor colorWithPatternImage:lImage];
    mLabelCircle.frame = CGRectMake(0, 0, lImage.size.width, lImage.size.height);
    mLabelCircle.hidden = YES;
    
    mImageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-[XSettingsCellSize cellSize].width*2, self.bounds.size.height-[XSettingsCellSize cellSize].height*2, [XSettingsCellSize cellSize].width*2, [XSettingsCellSize cellSize].height*2)];

    mImageViewArrow.image = [UIImage imageNamed:@"arrowH"];
    [self addSubview:mImageViewArrow];
    [mImageViewArrow release];
    [self animationForArrow];
    
    
    mLabelDisplaySize = [[UILabel alloc] init];
    mLabelDisplaySize.backgroundColor = [UIColor clearColor];
    mLabelDisplaySize.textColor = [UIColor greenColor];
    
//    [self addSubview:mLabelCircle];
    [self addSubview:mLabelDisplaySize];
    
    
    
    [mLabelCircle release];
    [mLabelDisplaySize release];
    
    isCanMoved = NO;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *lTouch = [[ touches allObjects ] objectAtIndex:0];
    CGPoint lPointTouch = [lTouch locationInView:self];
    
    mRectResize = CGRectMake(self.bounds.size.width-([XSettingsCellSize cellSize].width*2.0f), self.bounds.size.height-([XSettingsCellSize cellSize].height*2.0f), [XSettingsCellSize cellSize].width*4.0f, [XSettingsCellSize cellSize].height*4.0f);
    
    if (CGRectContainsPoint(mRectResize, lPointTouch)) {
//        mLabelCircle.hidden = NO;
        isCanMoved = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_RESIZE object:[NSNumber numberWithInt:1]];
        [self animationArrowStop];
        
    }
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *lTouch = [[touches allObjects] objectAtIndex:0];
    CGPoint lPointTouch = [lTouch locationInView:self];
    
    int lIntCountCellX = (lPointTouch.x+[XSettingsCellSize cellSize].width/2) / [XSettingsCellSize cellSize].width;
    int lIntCountCellY = (lPointTouch.y+[XSettingsCellSize cellSize].width/2) / [XSettingsCellSize cellSize].height;
    
    if (isCanMoved == YES) {
        
        lIntCountCellX = lIntCountCellX<CELL_COUNT_MIN ? CELL_COUNT_MIN : lIntCountCellX;
        lIntCountCellY = lIntCountCellY<CELL_COUNT_MIN ? CELL_COUNT_MIN : lIntCountCellY;
        
        lIntCountCellX = lIntCountCellX>CELL_COUNT_MAX ? CELL_COUNT_MAX : lIntCountCellX;
        lIntCountCellY = lIntCountCellY>CELL_COUNT_MAX ? CELL_COUNT_MAX : lIntCountCellY;  
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, lIntCountCellX*[XSettingsCellSize cellSize].width, lIntCountCellY*[XSettingsCellSize cellSize].height);
    }
    
    [self setNeedsDisplay];  
    
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if(isCanMoved == YES) {
        
        [self animationArrowStart];
    }
    
    isCanMoved = NO;
    
}

- (void) animationForArrow {
    
    CABasicAnimation *lAnimationForArrow = [CABasicAnimation animationWithKeyPath:@"position"];
	lAnimationForArrow.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    lAnimationForArrow.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width-[XSettingsCellSize cellSize].width, self.bounds.size.height-[XSettingsCellSize cellSize].height)];
    lAnimationForArrow.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width-[XSettingsCellSize cellSize].width*2, self.bounds.size.height-[XSettingsCellSize cellSize].height*2)];  
    
	lAnimationForArrow.repeatCount = 10.0f;
    lAnimationForArrow.removedOnCompletion = YES;
	lAnimationForArrow.duration = 0.3f;
    [lAnimationForArrow setAutoreverses:YES];
    lAnimationForArrow.delegate = self;
    [mImageViewArrow.layer addAnimation:lAnimationForArrow forKey:@"position"];
    //    mAnimationForArrow
}
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self animationForArrow];
    }
}
- (void) animationArrowStart {
    mImageViewArrow.frame = CGRectMake(self.bounds.size.width-[XSettingsCellSize cellSize].width*2, self.bounds.size.height-[XSettingsCellSize cellSize].height*2, [XSettingsCellSize cellSize].width*2, [XSettingsCellSize cellSize].height*2);
    mImageViewArrow.hidden = NO;
    [self animationForArrow];
    
}
- (void) animationArrowStop {
    mImageViewArrow.hidden = YES;
    [mImageViewArrow.layer removeAllAnimations];
}
- (void) drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetRGBFillColor(currentContext, 25/255.0, 120/255.0, 10/255.0, 1.0f);
    CGContextSetLineWidth(currentContext, 1);
    CGContextSetRGBStrokeColor(currentContext, 25/255.0, 120/255.0, 10/255.0, 1.0f);
    CGContextBeginPath(currentContext);    
    CGContextDrawPath(currentContext, kCGPathFillStroke); 
    
    for (int i=0; i<=self.bounds.size.width; i++) {
        CGContextMoveToPoint(currentContext, (i * [XSettingsCellSize cellSize].width), 0);
        CGContextAddLineToPoint(currentContext, (i * [XSettingsCellSize cellSize].width), rect.size.height);
    }
    for(int i=0; i<=self.bounds.size.height; i++) {
        CGContextMoveToPoint(currentContext, 0, (i * [XSettingsCellSize cellSize].height)); 
        CGContextAddLineToPoint(currentContext, rect.size.width, (i*[XSettingsCellSize cellSize].height));
    }
    
    CGContextStrokePath(currentContext);
    CGContextRestoreGState(currentContext);
    
    /*mLabelDisplaySize.text = [NSString stringWithFormat:@"%.0f%@%.0f", self.bounds.size.width/[XSettingsCellSize cellSize].width, @" x ", self.bounds.size.height/[XSettingsCellSize cellSize].height];
    mLabelDisplaySize.bounds = CGRectMake(0, 0, [mLabelDisplaySize.text sizeWithFont:mLabelDisplaySize.font].width, 40);
    mLabelDisplaySize.center = CGPointMake(rect.size.width/2, rect.size.height/2);*/
    
    NSString *lCurrentSize = [[NSString alloc] initWithFormat:@"%.0f%@%.0f", self.bounds.size.width/[XSettingsCellSize cellSize].width, @" x ", self.bounds.size.height/[XSettingsCellSize cellSize].height];
    if ([self displaySize]) {
        [self displaySize](lCurrentSize);
    }
    XSafeRelease(lCurrentSize);
    
//    mLabelCircle.center = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
}

- (void)dealloc { 
    
    
    [super dealloc];    
}

@end
