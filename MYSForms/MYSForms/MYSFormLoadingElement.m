//
//  MYSFormLoadingElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLoadingElement.h"

@implementation MYSFormLoadingElement

+ (instancetype)loadingFormElementWithParentFormElement:(MYSFormElement *)parentFormElement
{
    MYSFormLoadingElement *element = [MYSFormLoadingElement new];
    element.parentFormElement = parentFormElement;
    return element;
}

@end
