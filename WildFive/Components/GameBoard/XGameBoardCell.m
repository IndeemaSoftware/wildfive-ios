//
//  XGameBoardCell.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/11/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XGameBoardCell.h"
#import "XGameEnums.h"

@implementation XGameBoardCell

@synthesize currentUser=mState;
@synthesize symbolPosition=mSymbolPosition;

#pragma mark - Properties -

- (void) setCurrentUser:(XPlayerType)pCurrentUser {
//    UIBezierPath *lFigure;
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
//    switch (pCurrentUser) {
//        case XPlayerTypeCross:
//            [[UIColor greenColor] set];
//            lFigure = [UIBezierPath bezierPath];
//            [lFigure moveToPoint:CGPointMake(2, 2)];
//            [lFigure addLineToPoint:CGPointMake(self.frame.size.width - 2, self.frame.size.height - 2)];
//            [lFigure moveToPoint:CGPointMake(self.frame.size.width - 2, 2)];
//            [lFigure addLineToPoint:CGPointMake(2, self.frame.size.height - 2)];
//            break;
//        case XPlayerTypeToe:
//            [[UIColor yellowColor] set];
//            lFigure = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4) cornerRadius:(self.frame.size.height - 4) / 2];           
//            break;
//        case XPlayerTypeEmpty:
//            break;
//        default:
//            break;
//    }
//    [lFigure setLineWidth:2.0f];
//    [lFigure stroke];
//    UIImage *lNewImage = UIGraphicsGetImageFromCurrentImageContext();
//    [self setImage:lNewImage];
//    UIGraphicsEndImageContext();
    
    switch (pCurrentUser) {
        case XPlayerTypeCross:
            [mImageView setImage:[UIImage imageNamed:@"board_cross.png"]];
            break;
        case XPlayerTypeToe:
            [mImageView setImage:[UIImage imageNamed:@"board_toe.png"]];
            break;
        case XPlayerTypeEmpty:
            break;
        default:
            break;
    }
}

#pragma mark - Initialization -

- (id) initWithFrame:(CGRect)pFrame {

    
    self = [super initWithFrame:pFrame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        mState = XPlayerTypeEmpty;
        mImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [mImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:mImageView];
        
        [self setHighlightedImage:[UIImage imageNamed:@"highlighted_cell.png"]];
    }
    
    return self;
}

#pragma mark - Class methods -

+ (CGSize) cellSize {
    CGSize lSize;
    CGFloat lWidth;
    if([deviceType() isEqualToString:IPHONE]){
        lWidth = 16.3f;
    } else if([deviceType() isEqualToString:IPAD]){
        lWidth = 39.3f;
    }
    lSize.width = lWidth;
    lSize.height = lSize.width;
    
    return lSize;
}

- (void)dealloc {
    [mImageView release];
    [super dealloc];
}

@end
