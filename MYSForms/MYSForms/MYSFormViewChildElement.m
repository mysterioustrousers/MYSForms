//
//  MYSFormViewChildElement.m
//  MYSForms
//
//  Created by Adam Kirk on 7/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormViewChildElement.h"
#import "MYSFormChildElement-Private.h"


@interface MYSFormViewChildElement ()
@property (nonatomic, strong, readwrite) UIView *view;
@end


@implementation MYSFormViewChildElement

+ (instancetype)viewChildElementWithView:(UIView *)view parentElement:(MYSFormElement *)parentElement
{
    MYSFormViewChildElement *element = [MYSFormViewChildElement new];
    element.view                     = view;
    element.type                     = MYSFormChildElementTypeView;
    element.parentElement            = parentElement;
    return element;
}

@end
