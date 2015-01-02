//
//  MYSFormLabelAndButtonCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonCell.h"


@protocol MYSFormLabelAndButtonCellDelegate;


@interface MYSFormLabelAndButtonCell : MYSFormCell

@property (nonatomic, weak) id<MYSFormLabelAndButtonCellDelegate> labelAndButtonCellDelegate;

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet UIButton *button;

@end


@protocol MYSFormLabelAndButtonCellDelegate <NSObject>
- (void)formLabelAndButtonCell:(MYSFormLabelAndButtonCell *)cell didTapButton:(MYSFormButton *)button;
@end