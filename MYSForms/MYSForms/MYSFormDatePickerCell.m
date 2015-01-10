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


@interface MYSFormDatePickerCell ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation MYSFormDatePickerCell

- (void)populateWithElement:(MYSFormDatePickerElement *)element
{
    self.label.text = element.label;
    [super populateWithElement:element];
    self.button.enabled = element.isEnabled;
    [super populateWithElement:element];
    self.dateFormatter = element.dateFormatter;
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
