//
//  MYSFormErrorElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/9/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormMessageChildElement.h"
#import "MYSFormLoadingChildCell.h"
#import "MYSFormChildElement-Private.h"
#import "MYSFormTheme.h"


@interface MYSFormMessageChildElement ()
@property (nonatomic, copy, readwrite) NSString *message;
@end


@implementation MYSFormMessageChildElement

+ (instancetype)messageElementWithMessage:(NSString *)message type:(MYSFormChildElementType)type parentElement:(MYSFormElement *)parentElement
{
    MYSFormMessageChildElement *element = [MYSFormMessageChildElement new];
    element.message         = message;
    element.type            = type;
    element.parentElement   = parentElement;
    return element;
}

- (Class)cellClass
{
    if (self.type == MYSFormChildElementTypeLoading) {
        return [MYSFormLoadingChildCell class];
    }
    return [super cellClass];
}

- (BOOL)isEqual:(MYSFormMessageChildElement *)object
{
    return ([object isKindOfClass:[self class]] &&
            object.parentElement == self.parentElement &&
            object.type == self.type &&
            [object.message isEqualToString:self.message]);
}

- (NSUInteger)hash
{
    return [self.parentElement hash] ^ self.type ^ [self.message hash];
}

- (void)configureClassDefaultTheme:(MYSFormTheme *)theme
{
    theme.backgroundColor = [UIColor clearColor];
    theme.labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

@end
