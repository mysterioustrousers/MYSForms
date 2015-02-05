//
//  MYSFormNavigationCell.m
//  MYSForms
//
//  Created by Adam Kirk on 1/31/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormNavigationElement.h"
#import "MYSFormNavigationCell-Private.h"
#import "MYSFormTheme.h"


@interface MYSFormNavigationCell ()
@property (nonatomic, weak  ) IBOutlet UIButton *disclosureButton;
@property (nonatomic, weak  ) IBOutlet UILabel  *label;
@property (nonatomic, strong) UIColor *tempBackgroundColor;
@end


@implementation MYSFormNavigationCell

- (void)populateWithElement:(MYSFormNavigationElement *)element
{
    self.label.text = element.label;
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.label.font = theme.labelFont;
    self.label.textColor = theme.labelTextColor;
    [self setUpDisclosureIndicatorButton];
}


#pragma mark - Actions

- (IBAction)touchDown:(id)sender
{
    self.tempBackgroundColor = [self.backgroundColor copy];
    self.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)cellWasTapped:(id)sender
{
    self.backgroundColor = self.tempBackgroundColor;
    [self.navigationCellDelegate navigationCellDidTapCell:self];
}


#pragma mark - Private

- (void)setUpDisclosureIndicatorButton
{
    UITableViewCell *disclosureIndicator = [[UITableViewCell alloc] init];
    [self.disclosureButton addSubview:disclosureIndicator];
    disclosureIndicator.frame = self.disclosureButton.bounds;
    disclosureIndicator.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    disclosureIndicator.userInteractionEnabled = NO;
}

@end
