//
//  EEBoardView.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EEGameCommon.h"

@protocol EEBoardViewDelegate;

@interface EEBoardView : UIView

@property (nonatomic, weak) id <EEBoardViewDelegate> delegate;
@property (nonatomic, readonly) EEBoardSize boardSize;

- (void)reloadData;
- (void)reloadDataAtPoint:(EEBoardPoint)point;

@end


@protocol EEBoardViewDelegate <NSObject>

- (EEBoardSize)boardSizeBoardView:(EEBoardView*)boardView;
- (EEBoardSign)boardView:(EEBoardView*)boardView boardSignAtPoint:(EEBoardPoint)point;

@end
