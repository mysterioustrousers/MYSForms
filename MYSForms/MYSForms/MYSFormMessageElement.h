//
//  MYSFormErrorElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/9/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormMessageCell.h"


typedef NS_ENUM(NSUInteger, MYSFormMessageType) {
    MYSFormMessageTypeLoading,
    MYSFormMessageTypeValidationError,
    MYSFormMessageTypeError,
    MYSFormMessageTypeSuccess
};


@interface MYSFormMessageElement : MYSFormElement

@property (nonatomic, copy, readonly) NSString *message;

@property (nonatomic, assign, readonly) MYSFormMessageType type;

@property (nonatomic, weak, readonly) MYSFormElement *parentElement;

+ (instancetype)messageElementWithMessage:(NSString *)message type:(MYSFormMessageType)type parentElement:(MYSFormElement *)parentElement;

@end
