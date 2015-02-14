//
//  MYSFormTextViewElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/20/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormTextViewCell.h"


@interface MYSFormTextViewElement : MYSFormElement

@property (nonatomic, assign, getter=isEditable) BOOL editable;

+ (instancetype)textViewElementWithModelKeyPath:(NSString *)modelKeyPath;

@end
