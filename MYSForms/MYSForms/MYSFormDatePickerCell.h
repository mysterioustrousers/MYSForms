//
//  MYSFormDatePickerCell.h
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@class MYSFormButton;


@interface MYSFormDatePickerCell : MYSFormCell

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet MYSFormButton *button;

@property (nonatomic, copy) NSDate *selectedDate;

@end
