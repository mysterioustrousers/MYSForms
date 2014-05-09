//
//  MYSFormLabelAndButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonElement.h"
#import "MYSFormLabelAndButtonCell.h"


@interface MYSFormLabelAndButtonElement : MYSFormButtonElement

@property (nonatomic, copy) NSString *label;

+ (instancetype)buttonElementWithLabel:(NSString *)label title:(NSString *)title block:(MYSFormButtonActionBlock)block;

@end
