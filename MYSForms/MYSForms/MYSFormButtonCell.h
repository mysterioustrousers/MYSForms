//
//  MYSFormButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@protocol MYSFormButtonCellDelegate;


@interface MYSFormButtonCell : MYSFormCell

@property (nonatomic, weak) id<MYSFormButtonCellDelegate> buttonCellDelegate;

@property (nonatomic, weak) IBOutlet UIButton *button;

@end


@protocol MYSFormButtonCellDelegate <NSObject>
- (void)formButtonCell:(MYSFormButtonCell *)cell didTapButton:(UIButton *)button;
@end
