//
//  MYSFormLabelAndButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLabelAndButtonElement.h"


@implementation MYSFormLabelAndButtonElement

+ (instancetype)buttonElementWithLabel:(NSString *)label title:(NSString *)title block:(MYSFormButtonActionBlock)block
{
    MYSFormLabelAndButtonElement *element = [MYSFormLabelAndButtonElement new];
    element.label   = label;
    element.title   = title;
    element.block   = block;
    return element;
}

@end
