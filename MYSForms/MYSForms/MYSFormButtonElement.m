//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonElement.h"
#import "MYSFormButtonCell.h"


@implementation MYSFormButton

+ (instancetype)formButtonWithTitle:(NSString *)title action:(MYSFormButtonActionBlock)action
{
    MYSFormButton *button = [self new];
    button.action = action;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end


@interface MYSFormButtonElement () <MYSFormButtonCellDelegate>
@end


@implementation MYSFormButtonElement

+ (instancetype)buttonElementWithButtons:(NSArray *)buttons
{
    MYSFormButtonElement *element = [self new];
    element.buttons = buttons;
    return element;
}

- (void)setCell:(MYSFormButtonCell *)cell
{
    [super setCell:cell];
    cell.buttonCellDelegate = self;
}

- (void)setButtons:(NSArray *)buttons
{
    _buttons = [buttons copy];
    [self.cell setNeedsLayout];
}


#pragma mark - DELEGATE button cell

- (void)formButtonCell:(MYSFormButtonCell *)cell didTapButton:(MYSFormButton *)button
{
    if (button.action) button.action(self);
}

@end
