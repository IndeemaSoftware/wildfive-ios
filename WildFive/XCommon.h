//
//  XCommon.h
//  WildFive
//
//  Created by naceka on 14.02.12.
//  Copyright 2012 XIO Games. All rights reserved.
//

#import <Foundation/Foundation.h>
//*****************************ALL NOTIFICATONS*****************//

#define     ACTIVE_RESIZE                       @"active_resize"
#define     SETTINGS_CONTROLLER_DID_LOAD        @"settings_controller_did_load"
#define     SETTINGS_CONTROLLER_DID_DISAPPEAR   @"settings_controller_did_disappear"

//*****************************END NOTIFICATIONS****************//

@interface XCommon : NSObject {
    
}
+ (void) roundMyView:(UIView*)pView 
        borderRadius:(CGFloat)pRadius 
        borderWidth:(CGFloat)pBorder 
              color:(UIColor*)pColor;
+ (void) setAnimationForView:(UIView *)pView setDuration:(float)pDuration  setFrame:(CGRect)pFrame;
+ (void) setAnimationForView:(UIView *)pView setDuration:(float)pDuration  setCenter:(CGPoint)pCenter;
+ (void) setAnimationForView:(UIView*)pView
                 setDuration:(float)pDuration
                    setFrame:(CGRect)pFrame
                 setDelegate:(id)pDelegate
   setSelectorAfterAnimation:(SEL)pSelector;
+ (UIImage*) createContextRoundedRect:(CGRect)rect 
                        radiusTopLeft:(CGFloat)radiusTL 
                       radiusTopRight:(CGFloat)radiusTR 
                     radiusBottomLeft:(CGFloat)radiusBL 
                    radiusBottomRight:(CGFloat)radiusBR;


@end
