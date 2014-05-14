//
//  MYSFormImageFromDataValueTransformer.h
//  MYSForms
//
//  Created by Adam Kirk on 5/13/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


typedef NS_ENUM(NSUInteger, MYSFormImageFromDataValueTransformerReverseImageType) {
    MYSFormImageFromDataValueTransformerReverseImageTypeJPEG,
    MYSFormImageFromDataValueTransformerReverseImageTypePNG
};


@interface MYSFormImageFromDataValueTransformer : NSValueTransformer

@property (nonatomic, assign) MYSFormImageFromDataValueTransformerReverseImageType reverseTransformImageType;

+ (instancetype)valueTransformerWithReverseImageType:(MYSFormImageFromDataValueTransformerReverseImageType)type;

@end
