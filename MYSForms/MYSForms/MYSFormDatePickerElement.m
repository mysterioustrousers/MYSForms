//
//  MYSDatePickerElement.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormDatePickerElement.h"
#import "MYSFormDatePickerCell.h"
#import "MYSFormDatePickerCell-Private.h"


@interface MYSFormDatePickerElement () <MYSFormDatePickerCellDelegate>
@property (nonatomic, strong                  ) UIDatePicker *datePicker;
@property (nonatomic, assign, getter=isVisible) BOOL         visible;
@end


@implementation MYSFormDatePickerElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        _visible                    = NO;
        _datePicker                 = [UIDatePicker new];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self
                        action:@selector(datePickerDidChange:)
              forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


#pragma mark - Public

+ (instancetype)datePickerElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormDatePickerElement *element   = [self new];
    element.label                       = label;
    element.modelKeyPath                = modelKeyPath;
    return element;
}

- (void)setCell:(MYSFormDatePickerCell *)cell
{
    [super setCell:cell];
    cell.datePickerCellDelegate = self;
}

- (BOOL)isEditable
{
    return YES;
}


#pragma mark - Actions

- (IBAction)datePickerDidChange:(id)sender
{
    [self.delegate formElement:self valueDidChange:self.datePicker.date];
}


#pragma mark - DELEGATE picker cell

- (void)formDatePickerCellRequestedDatePicker:(MYSFormDatePickerCell *)cell
{
    id value = [self currentModelValue];
    self.datePicker.date = value ?: [NSDate date];
    if (!self.isVisible) {
        self.visible = YES;
        [self.delegate formElement:self didRequestPresentationOfChildView:self.datePicker];
    }
    else {
        self.visible = NO;
        [self.delegate formElement:self didRequestDismissalOfChildView:self.datePicker];
    }
}


@end
