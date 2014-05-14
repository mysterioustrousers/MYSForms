//
//  MYSFormToggleElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormToggleCell.h"


@interface MYSFormToggleElement : MYSFormElement

@property (nonatomic, copy) NSString *label;

+ (instancetype)toggleElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath;

@end
