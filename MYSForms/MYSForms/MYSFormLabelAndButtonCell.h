//
//  MYSFormLabelAndButtonCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@class MYSFormButton;


@protocol MYSFormLabelAndButtonCellDelegate;


@interface MYSFormLabelAndButtonCell : MYSFormCell

@property (nonatomic, weak) id<MYSFormLabelAndButtonCellDelegate> labelAndButtonCellDelegate;

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet MYSFormButton *button;

@end


@protocol MYSFormLabelAndButtonCellDelegate <NSObject>
- (void)formLabelAndButtonCell:(MYSFormLabelAndButtonCell *)cell didTapButton:(MYSFormButton *)button;
@end