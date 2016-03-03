//
//  XCreditsViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 10/10/12.
//
//

#import "QuartzCore/CALayer.h"
#import "XCreditsViewController.h"

@interface XCreditsViewController ()
//private properties
@end


@implementation XCreditsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mOptigraButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [mOptigraButton.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
    [mOptigraButton.layer setShadowOpacity:1.0f];
    
    [mAndreaButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [mAndreaButton.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
    [mAndreaButton.layer setShadowOpacity:0.8f];
    



    
    [mTitleLabel setText:NSLocalizedString(@"Credits", @"Credits")];
    [mOptigraLabel setText:NSLocalizedString(@"Developed by:", @"Credits")];
    NSString *lStr=[[NSString alloc] initWithString:@"All music provided by Italian composer                                             Andrea Carri:"];
    [mAndreaLabel setText:NSLocalizedString(lStr, @"Credits")];
    [lStr release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) optigraButton:(id)senderpSender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.optigra.org"]]; 
}

- (IBAction) andreaButton:(id)senderpSender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.soundcloud.com/andreacarri"]]; 
}

- (void)dealloc {
    [mBackgroundImageView release];
    [mBoardImageView release];
    [mTitleLabel release];
    [mOptigraLabel release];
    [mOptigraButton release];
    [mAndreaLabel release];
    [mAndreaButton release];
    
    [super dealloc];
}

@end
