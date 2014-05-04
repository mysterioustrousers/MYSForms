//
//  MYSFormElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"

@implementation MYSFormElement

- (Class)cellClass
{
    NSString *className     = NSStringFromClass([self class]);
    NSString *cellClassName = [className stringByReplacingOccurrencesOfString:@"Element" withString:@"Cell"];
    return NSClassFromString(cellClassName);
}

@end
