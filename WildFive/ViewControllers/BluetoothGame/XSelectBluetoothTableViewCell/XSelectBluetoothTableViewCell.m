//
//  XSelectBluetoothTableViewCell.m
//  WildFive
//
//  Created by Volodymyr Shevchyk jr. on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XSelectBluetoothTableViewCell.h"

@implementation XSelectBluetoothTableViewCell

@synthesize textLabel=mTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    if ([deviceType() isEqualToString:IPAD]) {
        [mBackgroundView setImage:[UIImage imageNamed:@"papir@2x~ipad.png"]];
        [mTitleLabel setFont:[mTitleLabel.font fontWithSize:25.0]];
    } else {
        [mBackgroundView setImage:[UIImage imageNamed:@"paper_cell.png"]];
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [self.textLabel setHighlighted:highlighted];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setHiddenBackground:(BOOL)pIsHidden {
    [mBackgroundView setHidden:pIsHidden];
}

- (void)dealloc {
    [mTitleLabel release];
    [mBackgroundView release];
    [super dealloc];
}

@end
