//
//  MYSFormHeadlineElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormHeadlineElement.h"


@implementation MYSFormHeadlineElement

+ (instancetype)headlineElementWithHeadline:(NSString *)headline
{
    MYSFormHeadlineElement *element = [MYSFormHeadlineElement new];
    element.headline = headline;
    return element;
}

@end
