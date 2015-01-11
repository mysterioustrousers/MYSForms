//
//  MYSFormHeadlineElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormLabelCell.h"


@interface MYSFormLabelElement : MYSFormElement

@property (nonatomic, copy) NSString *label;

+ (instancetype)labelElementWithText:(NSString *)text;

@end
