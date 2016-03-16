//
//  UIImage+Circle.m
//  VkChatter
//
//  Created by Yaroslav on 3/22/14.
//  Copyright (c) 2014 Yuki. All rights reserved.
//

#import "UIImage+Circle.h"
#import <CoreGraphics/CoreGraphics.h>

#define GRADIENT_IMAGE_NAME @"cover_gradient_image.png"
#define GRADIENT_IMAGE_SIZE 400.0f

@implementation UIImage (Circle)
+ (UIImage *)circleImageFromImage:(UIImage *)image {
    UIImage *lReturn = image;
    
    CGRect lImageFrame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 2.0);
    [[UIBezierPath bezierPathWithRoundedRect:lImageFrame
                                cornerRadius:lImageFrame.size.width / 2.0f] addClip];
    
    [image drawInRect:lImageFrame];
    lReturn = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return lReturn;
}

+ (UIImage*)gradientCoverImage {
    NSString *lGradientImagePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:GRADIENT_IMAGE_NAME];
    UIImage *lGradientImage = [UIImage imageWithContentsOfFile:lGradientImagePath];
    if (lGradientImage == nil) {
        CGSize lImageSize = CGSizeMake(GRADIENT_IMAGE_SIZE, GRADIENT_IMAGE_SIZE);
        CGRect lGradientRect = CGRectMake(0.0f, 0.0f, lImageSize.width, lImageSize.height);
        UIGraphicsBeginImageContextWithOptions(lImageSize, NO, [UIScreen mainScreen].scale);
        
        // Create a gradient from white to red
        CGFloat lColors [] = {
            0.0f, 0.0f, 0.0f, 0.9f,
            0.0f, 0.0f, 0.0f, 0.0f
        };
        
        CGColorSpaceRef lBaseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef lGradient = CGGradientCreateWithColorComponents(lBaseSpace, lColors, NULL, 2);
        CGColorSpaceRelease(lBaseSpace), lBaseSpace = NULL;
        
        CGContextRef lContext = UIGraphicsGetCurrentContext();
        
        CGPoint lCenterPoint = CGPointMake(CGRectGetMidX(lGradientRect), CGRectGetMidY(lGradientRect));
        
        CGContextDrawRadialGradient(lContext, lGradient, lCenterPoint, GRADIENT_IMAGE_SIZE * 0.8f, lCenterPoint, 0.0f, 0);
        CGGradientRelease(lGradient), lGradient = NULL;
        
        lGradientImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [UIImagePNGRepresentation(lGradientImage) writeToFile:lGradientImagePath atomically:YES];
        });
    }
    return lGradientImage;
}

@end
