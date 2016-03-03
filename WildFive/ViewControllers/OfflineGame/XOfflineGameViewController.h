//
//  XOfflineGameViewController.h
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr. on 16/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XGameViewControler.h"

@interface XOfflineGameViewController : XGameViewControler {
    IBOutlet UIImageView *mBackgroundImageView;
    
    NSTimer *mBotTimer;
}

@end
