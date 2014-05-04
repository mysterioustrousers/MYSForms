//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonElement.h"

@implementation MYSFormButtonElement

+ (instancetype)buttonFormElementWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    MYSFormButtonElement *element   = [MYSFormButtonElement new];
    element.title                   = title;
    element.target                  = target;
    element.action                  = action;
    return element;
}

@end
