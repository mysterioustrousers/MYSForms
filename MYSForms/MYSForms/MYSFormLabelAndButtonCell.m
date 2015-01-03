//
//  MYSFormLabelAndButtonCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLabelAndButtonCell.h"
#import "MYSFormLabelAndButtonElement.h"


@implementation MYSFormLabelAndButtonCell

- (void)populateWithElement:(MYSFormLabelAndButtonElement *)element
{
    self.label.text     = element.label;
    self.button.enabled = element.isEnabled;
    [self.button setTitle:[element.button titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    [super populateWithElement:element];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.button setTitleColor:[self tintColor] forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.labelAndButtonCellDelegate formLabelAndButtonCell:self didTapButton:sender];
}

@end
