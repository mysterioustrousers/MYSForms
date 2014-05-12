//
//  MYSFormErrorElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/9/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormMessageElement.h"
#import "MYSFormLoadingCell.h"


@interface MYSFormMessageElement ()
@property (nonatomic, copy,   readwrite) NSString           *message;
@property (nonatomic, weak,   readwrite) MYSFormElement     *parentElement;
@property (nonatomic, assign, readwrite) MYSFormMessageType type;
@end


@implementation MYSFormMessageElement

+ (instancetype)messageElementWithMessage:(NSString *)message type:(MYSFormMessageType)type parentElement:(MYSFormElement *)parentElement
{
    MYSFormMessageElement *element = [MYSFormMessageElement new];
    element.message         = message;
    element.type            = type;
    element.parentElement   = parentElement;
    return element;
}

- (Class)cellClass
{
    if (self.type == MYSFormMessageTypeLoading) {
        return [MYSFormLoadingCell class];
    }
    return [super cellClass];
}

@end
