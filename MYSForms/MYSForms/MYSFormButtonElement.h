//
//  MYSFormButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormButtonCell.h"


@interface MYSFormButtonElement : MYSFormElement
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) id       target;
@property (nonatomic, assign) SEL      action;
+ (instancetype)buttonFormElementWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
