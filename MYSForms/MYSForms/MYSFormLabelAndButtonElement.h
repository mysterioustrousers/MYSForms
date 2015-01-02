//
//  MYSFormLabelAndButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonElement.h"
#import "MYSFormLabelAndButtonCell.h"


@interface MYSFormLabelAndButtonElement : MYSFormElement

@property (nonatomic, copy) NSString *label;

@property (nonatomic, strong) MYSFormButton *button;

+ (instancetype)labelAndButtonElementWithLabel:(NSString *)label button:(MYSFormButton *)button;

@end
