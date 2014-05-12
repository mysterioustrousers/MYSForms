//
//  MYSFormImagePickerElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormImagePickerElement.h"

@implementation MYSFormImagePickerElement

+ (instancetype)imagePickerElementWithImage:(UIImage *)image label:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormImagePickerElement *element  = [MYSFormImagePickerElement new];
    element.image                       = image;
    element.label                       = label;
    element.modelKeyPath                = modelKeyPath;
    return element;
}

@end
