//  XViewSizeSettingsBackBoard.h
//  WildFive
//
//  Created by naceka on 21.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGameEnums.h"
@class XSettingsViewSizeAboveBoard;



@interface XSettingsViewSizeBackBoard : UIView {
    
    XSettingsViewSizeAboveBoard     *mViewAboveBoard;
    NSMutableArray                  *mArrayLabels;
    
}
@property(nonatomic, retain)XSettingsViewSizeAboveBoard *viewAboveBoard;
- (void) createAboveView:(XBoardSize)pSize;


@end