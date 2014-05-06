//
//  MYSFormValidation.m
//  MYSForms
//
//  Created by Adam Kirk on 5/5/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormValidation.h"

@implementation MYSFormValidation

+ (instancetype)validationWithFailedString:(NSString *)failedString
{
    MYSFormValidation *formValidation = [[self class] new];
    formValidation.failedString = failedString;
    return formValidation;
}

- (NSError *)errorFromValidatingValue:(id)value;
{
    NSAssert(NO, @"This class MUST be subclassed and this method overriden without calling super.");
    return nil;
}




#pragma mark - Equality

- (BOOL)isEqual:(MYSFormValidation *)otherValidation
{
    return [otherValidation isMemberOfClass:[self class]] && [otherValidation.failedString isEqual:self.failedString];
}

- (NSUInteger)hash
{
    return [self.failedString hash];
}

@end


NSString * const MYSFormErrorDomain = @"MYSFormErrorDomain";
