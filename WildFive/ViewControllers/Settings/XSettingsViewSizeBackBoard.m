//
//  XViewSizeSettingsBackBoard.m
//  WildFive
//
//  Created by naceka on 21.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XSettingsViewSizeBackBoard.h"
#import "XSettingsCellSize.h"
#import "XSettingsViewSizeAboveBoard.h"


#define SIZE_NUMBER 0.0f
#define SIZE_CELL_OFFSET 0.0f
@interface XSettingsViewSizeBackBoard()
@property(nonatomic, retain) IBOutlet UILabel *lblDisplaySize;

@end
@implementation XSettingsViewSizeBackBoard
@synthesize viewAboveBoard = mViewAboveBoard;
@synthesize lblDisplaySize=_lblDisplaySize;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {      
        
    }
    return self;
}
- (void) createAboveView:(XBoardSize)pSize {
    self.backgroundColor = [UIColor clearColor];
    //    CGFloat lStartSize = 5.0f;
    mViewAboveBoard = [[XSettingsViewSizeAboveBoard alloc] initWithFrame:CGRectMake(SIZE_CELL_OFFSET*[XSettingsCellSize cellSize].width, SIZE_CELL_OFFSET*[XSettingsCellSize cellSize].height, pSize.width*[XSettingsCellSize cellSize].width, pSize.height*[XSettingsCellSize cellSize].height)];        
    [self addSubview:mViewAboveBoard];
    [mViewAboveBoard initData];
    [mViewAboveBoard release];  
    [mViewAboveBoard setDisplaySize:^(NSString *currentSize) {
        _lblDisplaySize.text = currentSize;
    }];
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    [mViewAboveBoard touchesBegan:touches withEvent:event ];
    
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event { 
    
    [mViewAboveBoard touchesMoved:touches withEvent:event ];
    
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    [mViewAboveBoard touchesEnded:touches withEvent:event];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) drawRect:(CGRect)rect {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetRGBFillColor(currentContext, 0/255.0, 0/255.0, 0/255.0, 1.0f);
    CGContextSetLineWidth(currentContext, 1);
    CGContextSetRGBStrokeColor(currentContext, 0/255.0, 0/255.0, 0/255.0, 1.0f);
    CGContextBeginPath(currentContext);
    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    for (int i=SIZE_CELL_OFFSET; i<=(self.bounds.size.width/[XSettingsCellSize cellSize].width); i++) {
        CGContextMoveToPoint(currentContext, (i * [XSettingsCellSize cellSize].width), [XSettingsCellSize cellSize].height*SIZE_CELL_OFFSET);
        CGContextAddLineToPoint(currentContext, (i * [XSettingsCellSize cellSize].width), rect.size.height);
    }
    for(int i=SIZE_CELL_OFFSET; i<=(self.bounds.size.height/[XSettingsCellSize cellSize].height); i++) {
        CGContextMoveToPoint(currentContext, [XSettingsCellSize cellSize].width*SIZE_CELL_OFFSET, (i * [XSettingsCellSize cellSize].height)); 
        CGContextAddLineToPoint(currentContext, rect.size.width, (i*[XSettingsCellSize cellSize].height));
        
    }
    
    CGContextStrokePath(currentContext);
    CGContextRestoreGState(currentContext);   
    
}

- (void)dealloc {
    [super dealloc];
}

@end
