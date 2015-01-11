//
//  MYSFormPickerCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@class MYSFormButton;


@interface MYSFormPickerCell : MYSFormCell

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet MYSFormButton *button;

@property (nonatomic, copy) NSString *selectedValue;

@end
