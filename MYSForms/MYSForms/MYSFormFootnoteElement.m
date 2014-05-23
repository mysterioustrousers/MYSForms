//
//  MYSFormFootnoteElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormFootnoteElement.h"

@implementation MYSFormFootnoteElement

+ (instancetype)footnoteElementWithFootnote:(NSString *)footnote
{
    MYSFormFootnoteElement *element = [self new];
    element.footnote = footnote;
    return element;
}

@end
