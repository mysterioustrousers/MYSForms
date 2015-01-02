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
    self.button         = element.button;
    self.button.enabled = element.isEnabled;

    if ([[self.button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] == 0) {
        [self.button removeTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

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
