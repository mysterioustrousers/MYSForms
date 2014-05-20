//
//  MYSFormStringFromURLValueTransformer.m
//  MYSForms
//
//  Created by Adam Kirk on 5/20/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormStringFromURLValueTransformer.h"


@implementation MYSFormStringFromURLValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (NSString *)transformedValue:(NSURL *)value
{
    return [value absoluteString];
}

- (NSURL *)reverseTransformedValue:(NSString *)value
{
    if (![value hasPrefix:@"http"]) {
        value = [NSString stringWithFormat:@"http://%@", value];
    }
    return [NSURL URLWithString:value];
}

@end
