//
//  MYSFormTextFieldElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormTextFieldCell.h"


@interface MYSFormTextFieldElement : MYSFormElement

@property (nonatomic, copy) NSString *label;

@property (nonatomic, assign, getter=isSecure) BOOL secure;

@property (nonatomic, assign) UIKeyboardType keyboardType;

+ (instancetype)textFieldElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath;

@end
