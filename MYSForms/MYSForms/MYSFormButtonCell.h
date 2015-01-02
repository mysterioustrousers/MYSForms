//
//  MYSFormButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@class MYSFormButton;


@protocol MYSFormButtonCellDelegate;


@interface MYSFormButtonCell : MYSFormCell

@property (nonatomic, weak) id<MYSFormButtonCellDelegate> buttonCellDelegate;

@property (nonatomic) CGFloat buttonSpacing;

@end


@protocol MYSFormButtonCellDelegate <NSObject>
- (void)formButtonCell:(MYSFormButtonCell *)cell didTapButton:(MYSFormButton *)button;
@end
