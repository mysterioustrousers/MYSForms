//
//  MYSFormPickerCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormPickerCell.h"
#import "MYSFormPickerCell-Private.h"
#import "MYSFormPickerElement.h"


@implementation MYSFormPickerCell

- (void)populateWithElement:(MYSFormPickerElement *)element
{
    self.label.text = element.label;
    [super populateWithElement:element];
    self.button.enabled = element.isEnabled;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

- (NSString *)buttonTitle
{
    return [self.button titleForState:UIControlStateNormal];
}

- (NSString *)valueKeyPath
{
    return @"buttonTitle";
}




#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.pickerCellDelegate formPickerCellRequestedPicker:self];
}

@end
