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

@property (nonatomic, copy) NSArray *buttons;

+ (instancetype)buttonElementWithButtons:(NSArray *)buttons;

@end