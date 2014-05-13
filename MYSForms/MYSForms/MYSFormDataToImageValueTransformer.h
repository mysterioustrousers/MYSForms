//
//  MYSFormDataToImageValueTransformer.h
//  MYSForms
//
//  Created by Adam Kirk on 5/13/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


typedef NS_ENUM(NSUInteger, MYSFormDataToImageValueTransformerReverseImageType) {
    MYSFormDataToImageValueTransformerReverseImageTypeJPEG,
    MYSFormDataToImageValueTransformerReverseImageTypePNG
};


@interface MYSFormDataToImageValueTransformer : NSValueTransformer
@property (nonatomic, assign) MYSFormDataToImageValueTransformerReverseImageType reverseTransformImageType;
+ (instancetype)valueTransformerWithReverseImageType:(MYSFormDataToImageValueTransformerReverseImageType)type;
@end
