//
//  MYSFormImageFromDataValueTransformer.m
//  MYSForms
//
//  Created by Adam Kirk on 5/13/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormImageFromDataValueTransformer.h"

@implementation MYSFormImageFromDataValueTransformer

+ (instancetype)valueTransformerWithReverseImageType:(MYSFormImageFromDataValueTransformerReverseImageType)type
{
    MYSFormImageFromDataValueTransformer *transformer = [MYSFormImageFromDataValueTransformer new];
    transformer.reverseTransformImageType = type;
    return transformer;
}

+ (Class)transformedValueClass
{
    return [UIImage class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (UIImage *)transformedValue:(NSData *)value
{
    return [UIImage imageWithData:value];
}

- (NSData *)reverseTransformedValue:(UIImage *)value
{
    if (self.reverseTransformImageType == MYSFormImageFromDataValueTransformerReverseImageTypePNG) {
        return UIImagePNGRepresentation(value);
    }
    else if (self.reverseTransformImageType == MYSFormImageFromDataValueTransformerReverseImageTypeJPEG) {
        return UIImageJPEGRepresentation(value, 0.9);
    }
    return nil;
}

@end
