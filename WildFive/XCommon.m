//
//  XCommon.m
//  WildFive
//
//  Created by naceka on 14.02.12.
//  Copyright 2012 XIO Games. All rights reserved.
//


// Class for common methods which you are using in your classes;

#import <QuartzCore/QuartzCore.h>
#import "XCommon.h"



@implementation XCommon
+ (void) roundMyView:(UIView *)pView 
       borderRadius:(CGFloat)pRadius 
       borderWidth:(CGFloat)pBorder 
       color:(UIColor *)pColor 
{
    CALayer *layer = [pView layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = pRadius;
    layer.borderWidth = pBorder;
    layer.borderColor = pColor.CGColor;
    
}
+ (void) setAnimationForView:(UIView *)pView 
                    setDuration:(float)pDuration  
                    setFrame:(CGRect)pFrame
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:pDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    pView.frame = pFrame;
    [UIView commitAnimations];
}
+ (void) setAnimationForView:(UIView *)pView 
                 setDuration:(float)pDuration  
                 setCenter:(CGPoint)pCenter
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:pDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    pView.center = pCenter;
    [UIView commitAnimations];
    
}
+ (void) setAnimationForView:(UIView*)pView
                 setDuration:(float)pDuration
                 setFrame:(CGRect)pFrame
                 setDelegate:(id)pDelegate
                 setSelectorAfterAnimation:(SEL)pSelector {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:pDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:pDelegate];
    [UIView setAnimationDidStopSelector:pSelector];
    pView.frame = pFrame;
 
    [UIView commitAnimations];
        
}
+ (UIImage*) createContextRoundedRect:(CGRect)rect 
                            radiusTopLeft:(CGFloat)radiusTL 
                            radiusTopRight:(CGFloat)radiusTR 
                            radiusBottomLeft:(CGFloat)radiusBL 
                            radiusBottomRight:(CGFloat)radiusBR
{  
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace;    
//    colorSpace = CGColorSpaceCreateDeviceRGB(); 
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //****my
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 12.0/255.0, 12.0/255.0, 12.0/255.0, 1.0f);
    CGContextSetLineWidth(context, 3);
    CGContextSetRGBStrokeColor(context, 12.0/255.0, 12.0/255.0, 12.0/255.0, 1.0f);
    //****my 
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);     
    if ( context == NULL ) {
        return NULL;
    }
    
    // cerate mask    
    CGFloat minx = CGRectGetMinX(rect);    
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);    
    CGFloat maxy = CGRectGetMaxY(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat midy = CGRectGetMidY(rect);
    
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 1.0, 0.0);
    CGContextAddRect(context, rect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radiusBL);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radiusBR);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radiusTR);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radiusTL);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef bitmapContext = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // convert the finished resized image to a UIImage 
    UIImage *lImage = [UIImage imageWithCGImage:bitmapContext];
    // image is retained by the property setting above, so we can 
    // release the original
    CGImageRelease(bitmapContext);
    
    // return the image
    return lImage;
} 

@end
