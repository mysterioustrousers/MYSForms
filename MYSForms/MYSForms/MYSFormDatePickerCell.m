//
//  MYSFormDatePickerCell.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormDatePickerCell.h"
#import "MYSFormDatePickerCell-Private.h"
#import "MYSFormDatePickerElement.h"
#import "MYSFormButton.h"
#import "MYSFormTheme.h"


@interface MYSFormDatePickerCell ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation MYSFormDatePickerCell

- (void)populateWithElement:(MYSFormDatePickerElement *)element
{
    self.label.text     = element.label;
    self.button.enabled = element.isEnabled;
    self.dateFormatter  = element.dateFormatter;
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
    return @"selectedDate";
}

- (void)didChangeValueAtValueKeyPath
{
    if (!self.dateFormatter) {
        self.dateFormatter = [NSDateFormatter new];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    NSString *title = [self.dateFormatter stringFromDate:self.selectedDate];
    [self.button setTitle:title forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.datePickerCellDelegate formDatePickerCellRequestedDatePicker:self];
}

@end
