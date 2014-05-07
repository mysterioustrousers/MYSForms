//
//  MYSFormLabelAndButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLabelAndButtonElement.h"

@implementation MYSFormLabelAndButtonElement

+ (instancetype)formElementWithLabel:(NSString *)label buttonTitle:(NSString *)buttonTitle target:(id)target action:(SEL)action
{
    MYSFormLabelAndButtonElement *element = [MYSFormLabelAndButtonElement new];
    element.label       = label;
    element.buttonTitle = buttonTitle;
    element.target      = target;
    element.action      = action;
    return element;
}

@end
