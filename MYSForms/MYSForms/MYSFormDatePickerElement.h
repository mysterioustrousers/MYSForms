//
//  MYSDatePickerElement.h
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormDatePickerCell.h"


@interface MYSFormDatePickerElement : MYSFormElement

+ (instancetype)datePickerElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath;

/**
 The date picker that will be presented when this element is tapped. Exposed for your customizing pleasure.
 */
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

/**
 The label that appears as the title of what the user is picking a date for.
 */
@property (nonatomic, copy) NSString *label;

/**
 `YES` if the picker has currently been toggled visible in the form.
 */
@property (nonatomic, assign, readonly, getter = isVisible) BOOL visible;

/**
 The date formatter to use when displaying the currently selected date on the element. (optional)
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
