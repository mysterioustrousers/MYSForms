//
//  MYSFormLabelAndButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormLabelAndButtonCell.h"

@interface MYSFormLabelAndButtonElement : MYSFormElement
@property (nonatomic, copy  ) NSString *label;
@property (nonatomic, copy  ) NSString *buttonTitle;
@property (nonatomic, strong) id       target;
@property (nonatomic, assign) SEL      action;
+ (instancetype)formElementWithLabel:(NSString *)label buttonTitle:(NSString *)buttonTitle target:(id)target action:(SEL)action;
@end
