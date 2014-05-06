//
//  MYSFormErrorElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/5/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormErrorElement.h"


@implementation MYSFormErrorElement

+ (instancetype)errorFormElementWithError:(NSString *)error
{
    MYSFormErrorElement *element = [MYSFormErrorElement new];
    element.error = error;
    return element;
}

@end
