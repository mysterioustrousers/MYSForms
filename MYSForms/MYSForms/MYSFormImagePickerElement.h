//
//  MYSFormImagePickerElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormImagePickerCell.h"


@interface MYSFormImagePickerElement : MYSFormElement

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *label;

+ (instancetype)imagePickerElementWithImage:(UIImage *)image label:(NSString *)label modelKeyPath:(NSString *)modelKeyPath;

@end
