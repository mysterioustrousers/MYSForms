//
//  MYSFormTextFieldElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextFieldElement.h"

@implementation MYSFormTextFieldElement

+ (instancetype)textFieldFormElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormTextFieldElement *element    = [MYSFormTextFieldElement new];
    element.label                       = label;
    element.modelKeyPath                = modelKeyPath;
    element.secure                      = NO;
    element.keyboardType                = UIKeyboardTypeDefault;
    return element;
}

- (BOOL)isTextInput
{
    return YES;
}

@end
