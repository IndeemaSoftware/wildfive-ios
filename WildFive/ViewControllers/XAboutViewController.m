//
//  XAboutViewController.m
//  WildFive
//
//  Created by Volodymyr Shevchyk on 2/8/12.
//  Copyright (c) 2012 XIO Games. All rights reserved.
//

#import "XAboutViewController.h"
#import "XCreditsViewController.h"

#define ANIM_TIME_INTERVAL 0.7f
@interface XAboutViewController()
//private properties
@end

@implementation XAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
    // Do any additional setup after loading the view from its nib.
    mAboutText.editable=NO;
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_screen_3@2X.png"]];
//    IBOutlet UILabel *mTitleLabel;
//    IBOutlet UIButton *mCreditsButton;
//    IBOutlet UITextView *mAboutText;
    [mTitleLabel setText:NSLocalizedString(@"How to play", @"About")];
    NSString *lAboutStr=@"The objective is to construct a continuous series of players with exactly five characters of his color vertically, horizontally or diagonally.The game goes to infinite field. No fouls. Construction of a long series (5 or more consecutive pieces) brings victory.\n\n How to play:\nclick on the display and hold pressure,move item to the desired location, wait for locks your item and release";
    [mAboutText setText:NSLocalizedString(lAboutStr, @"AboutVC")];
    [lAboutStr release];
    [mHowToPlayButton setTitle:NSLocalizedString(@"Show", @"AboutVC") forState:UIControlStateNormal];
    


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"---unload");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBackButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)creditsButtonPressed:(id)pSender {
    XCreditsViewController *lViewController = [[XCreditsViewController alloc] initWithNibName:@"XCreditsViewController" bundle:nil];
    [self.navigationController pushViewController:lViewController animated:YES];
    [lViewController release];
}
- (void)hideBoard{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:ANIM_TIME_INTERVAL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
        [mBoardImageView setAlpha:0.0f];
        [mAboutText setAlpha:0.0f];
        [mTitleLabel setAlpha:0.0f];
        [mCreditsButton setAlpha:0.0f];
        [mHowToPlayButton setAlpha:0.0f];
    
    [UIView commitAnimations];
}

- (void)showBoard{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:ANIM_TIME_INTERVAL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [mBoardImageView setAlpha:1.0f];
    [mAboutText setAlpha:1.0f];
    [mTitleLabel setAlpha:1.0f];
    [mCreditsButton setAlpha:1.0f];
    [mHowToPlayButton setAlpha:1.0f];
    
    [UIView commitAnimations];
}

-(void)showTutorial{
    CGRect lAnimRect;
    if([deviceType() isEqualToString:IPHONE]){
        lAnimRect = CGRectMake(10.0f, 70.0f, 300.0f, 400.0f);
        if(IS_IPHONE_5){
            
        }
    }else if([deviceType() isEqualToString:IPAD]){
        lAnimRect = CGRectMake(14.0f, 120.0f, 740.0f, 890.0f);
    }
    mAnimDoc = [[XAnimationDoc alloc] initWithFrame:lAnimRect];
    mAnimDoc.delegate = self;
    [self.view addSubview:mAnimDoc];
    [mAnimDoc setAlpha:0.7f];
}

- (IBAction)howToPlayButtonPressed:(id)sender{
    DLog(@"how to play...");
    [self hideBoard];
    [self performSelector:@selector(showTutorial) withObject:nil afterDelay:ANIM_TIME_INTERVAL];
 
}

- (void)dealloc {
    DLog(@"dealloc_about");
    [NSObject cancelPreviousPerformRequestsWithTarget:mAnimDoc];
    [mAnimDoc removeFromSuperview];
    [mAnimDoc release];
    
    [mHowToPlayButton release];
    [mBackgroundImageView release];
    [mBoardImageView release];
    [mTitleLabel release];
    [mCreditsButton release];
    [mAboutText release];
    [super dealloc];
}
#pragma mark - XAnimateDelegate methods

- (void)animationDidStart{
    DLog(@"- - - animation Did Start - - - ");
}

-(void)animationDidEnd{
    DLog(@"- - - animation Did End - - - ");
    [self showBoard];
    XSafeRelease(mAnimDoc);
}
@end
