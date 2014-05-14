//
//  MYSFormPickerCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormPickerCell.h"


@protocol MYSFormPickerCellDelegate;


@interface MYSFormPickerCell ()
@property (nonatomic, weak) id<MYSFormPickerCellDelegate> pickerCellDelegate;
@end


@protocol MYSFormPickerCellDelegate <NSObject>
- (void)formPickerCellRequestedPicker:(MYSFormPickerCell *)cell;
@end