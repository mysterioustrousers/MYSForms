//
//  MYSFormStringFromTimeZoneValueTransformer.m
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormStringFromTimeZoneValueTransformer.h"

@implementation MYSFormStringFromTimeZoneValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (NSString *)transformedValue:(NSTimeZone *)value
{
    return [value name];
}

- (NSTimeZone *)reverseTransformedValue:(NSString *)value
{
    return [NSTimeZone timeZoneWithName:value];
}

@end
