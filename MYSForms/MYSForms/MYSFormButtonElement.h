//
//  MYSFormButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormButtonCell.h"


@class MYSFormButtonElement;


typedef void(^MYSFormButtonActionBlock)(MYSFormButtonElement *element);


@interface MYSFormButtonElement : MYSFormElement

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) MYSFormButtonActionBlock block;

+ (instancetype)buttonElementWithTitle:(NSString *)title block:(MYSFormButtonActionBlock)block;

@end
