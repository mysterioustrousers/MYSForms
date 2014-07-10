//
//  MYSFormViewChildElement.h
//  MYSForms
//
//  Created by Adam Kirk on 7/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormChildElement.h"

@interface MYSFormViewChildElement : MYSFormChildElement

+ (instancetype)viewChildElementWithView:(UIView *)view parentElement:(MYSFormElement *)parentElement;

/**
 The view this child element should display.
 */
@property (nonatomic, strong, readonly) UIView *view;

@end
