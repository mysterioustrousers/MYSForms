//
//  MYSFormLabelAndButtonCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLabelAndButtonCell.h"
#import "MYSFormLabelAndButtonElement.h"
#import "MYSFormButton.h"
#import "MYSFormTheme.h"


@implementation MYSFormLabelAndButtonCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.button setTitleColor:[self tintColor] forState:UIControlStateNormal];
}

- (void)populateWithElement:(MYSFormLabelAndButtonElement *)element
{
    self.label.text     = element.label;
    self.button.enabled = element.isEnabled;
    [self.button setTitle:[element.button titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.label.font         = theme.labelFont;
    self.label.textColor    = theme.labelTextColor;
    if (self.button.buttonStyle == MYSFormButtonStyleNone) {
        self.button.buttonStyle = [theme.buttonStyle integerValue];
    }
    self.button.titleLabel.font = theme.buttonTitleFont;
}


#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.labelAndButtonCellDelegate formLabelAndButtonCell:self didTapButton:sender];
}

@end
