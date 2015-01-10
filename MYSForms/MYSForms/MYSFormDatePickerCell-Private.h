//
//  MYSFormDatePickerCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//


#import "MYSFormDatePickerCell.h"


@protocol MYSFormDatePickerCellDelegate;


@interface MYSFormDatePickerCell ()
@property (nonatomic, weak) id<MYSFormDatePickerCellDelegate> datePickerCellDelegate;
@end


@protocol MYSFormDatePickerCellDelegate <NSObject>
- (void)formDatePickerCellRequestedDatePicker:(MYSFormDatePickerCell *)cell;
@end