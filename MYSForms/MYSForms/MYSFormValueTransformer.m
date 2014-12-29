//
//  MYSFormBlockValueTransformer.m
//  MYSForms
//
//  Adapted by Adam Kirk on 12/27/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//
//  Adapted from:
//
//  MYSFormValueTransformer.m
//  Mantle
//
//  Created by Justin Spahr-Summers on 2012-09-11.
//
//  Copyright (c) 2012 - 2014, GitHub, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MYSFormValueTransformer.h"


//
// Any MYSFormValueTransformer supporting reverse transformation. Necessary because
// +allowsReverseTransformation is a class method.
//
@interface MYSFormReversibleValueTransformer : MYSFormValueTransformer
@end


@interface MYSFormValueTransformer ()
@property (nonatomic, copy, readonly) MYSFormValueTransformerBlock forwardBlock;
@property (nonatomic, copy, readonly) MYSFormValueTransformerBlock reverseBlock;
@end


@implementation MYSFormValueTransformer

#pragma mark - Public

+ (instancetype)transformerWithBlock:(MYSFormValueTransformerBlock)transformationBlock {
    return [[self alloc] initWithForwardBlock:transformationBlock reverseBlock:nil];
}

+ (instancetype)reversibleTransformerWithBlock:(MYSFormValueTransformerBlock)transformationBlock {
    return [self reversibleTransformerWithForwardBlock:transformationBlock reverseBlock:transformationBlock];
}

+ (instancetype)reversibleTransformerWithForwardBlock:(MYSFormValueTransformerBlock)forwardBlock reverseBlock:(MYSFormValueTransformerBlock)reverseBlock {
    return [[MYSFormReversibleValueTransformer alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

#pragma mark - Private

- (id)initWithForwardBlock:(MYSFormValueTransformerBlock)forwardBlock reverseBlock:(MYSFormValueTransformerBlock)reverseBlock {
    NSParameterAssert(forwardBlock != nil);

    self = [super init];
    if (self == nil) return nil;

    _forwardBlock = [forwardBlock copy];
    _reverseBlock = [reverseBlock copy];

    return self;
}

#pragma mark NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return NO;
}

+ (Class)transformedValueClass {
    return [NSObject class];
}

- (id)transformedValue:(id)value {
    return self.forwardBlock(value);
}

@end


@implementation MYSFormReversibleValueTransformer

- (id)initWithForwardBlock:(MYSFormValueTransformerBlock)forwardBlock reverseBlock:(MYSFormValueTransformerBlock)reverseBlock {
    NSParameterAssert(reverseBlock != nil);
    return [super initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

#pragma mark NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)reverseTransformedValue:(id)value {
    return self.reverseBlock(value);
}

@end
