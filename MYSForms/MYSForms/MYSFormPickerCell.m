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
#import "MYSFormButton.h"
#import "MYSFormTheme.h"


@implementation MYSFormPickerCell

- (void)populateWithElement:(MYSFormPickerElement *)element
{
    self.label.text = element.label;
    self.button.enabled = element.isEnabled;
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

- (NSString *)valueKeyPath
{
    return @"selectedValue";
}

- (void)modelValueDidChange
{
    [self.button setTitle:self.selectedValue forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.pickerCellDelegate formPickerCellRequestedPicker:self];
}

@end
