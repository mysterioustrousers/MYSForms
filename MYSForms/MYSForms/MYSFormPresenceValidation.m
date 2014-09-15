//
//  MYSFormPresenceValidation.m
//  MYSForms
//
//  Created by Adam Kirk on 5/5/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormPresenceValidation.h"

@implementation MYSFormPresenceValidation

- (NSString *)failedString
{
    return [super failedString] ?: @"Can't be blank.";
}

- (NSError *)errorFromValidatingValue:(id)value;
{
    if ([value respondsToSelector:@selector(length)] && [value length] > 0) {
        return nil;
    }
    if ([value respondsToSelector:@selector(count)] && [value count] > 0) {
        return nil;
    }
    if ([value isKindOfClass:[UIImage class]]) {
        return nil;
    }
    return [NSError errorWithDomain:MYSFormErrorDomain
                               code:1
                           userInfo:@{ NSLocalizedDescriptionKey : self.failedString,
                                       NSLocalizedFailureReasonErrorKey : self.failedString }];
}

@end
