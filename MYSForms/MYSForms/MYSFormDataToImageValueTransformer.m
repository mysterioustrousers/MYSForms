//
//  MYSFormDataToImageValueTransformer.m
//  MYSForms
//
//  Created by Adam Kirk on 5/13/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormDataToImageValueTransformer.h"

@implementation MYSFormDataToImageValueTransformer

+ (instancetype)valueTransformerWithReverseImageType:(MYSFormDataToImageValueTransformerReverseImageType)type
{
    MYSFormDataToImageValueTransformer *transformer = [MYSFormDataToImageValueTransformer new];
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
    if (self.reverseTransformImageType == MYSFormDataToImageValueTransformerReverseImageTypePNG) {
        return UIImagePNGRepresentation(value);
    }
    else if (self.reverseTransformImageType == MYSFormDataToImageValueTransformerReverseImageTypeJPEG) {
        return UIImageJPEGRepresentation(value, 0.9);
    }
    return nil;
}

@end
