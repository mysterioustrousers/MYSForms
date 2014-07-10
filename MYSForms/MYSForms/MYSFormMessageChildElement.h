//
//  MYSFormErrorElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/9/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormChildElement.h"
#import "MYSFormMessageChildCell.h"


@interface MYSFormMessageChildElement : MYSFormChildElement

@property (nonatomic, copy, readonly) NSString *message;

+ (instancetype)messageElementWithMessage:(NSString *)message type:(MYSFormChildElementType)type parentElement:(MYSFormElement *)parentElement;

@end
