//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonElement.h"
#import "MYSFormButtonCell.h"
#import "private.h"


@interface MYSFormButtonElement () <MYSFormButtonCellDelegate>
@end


@implementation MYSFormButtonElement

+ (instancetype)buttonElementWithTitle:(NSString *)title block:(MYSFormButtonActionBlock)block
{
    MYSFormButtonElement *element   = [MYSFormButtonElement new];
    element.title                   = title;
    element.block                   = block;
    return element;
}

- (void)setCell:(MYSFormButtonCell *)cell
{
    [super setCell:cell];
    cell.buttonCellDelegate = self;
}




#pragma mark - DELEGATE button cell

- (void)formButtonCell:(MYSFormButtonCell *)cell didTapButton:(UIButton *)button
{
    if (self.block) self.block(self);
}

@end
