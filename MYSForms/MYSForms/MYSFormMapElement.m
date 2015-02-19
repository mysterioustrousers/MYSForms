//
//  MYSFormMapElement.m
//  MYSForms
//
//  Created by Adam Kirk on 7/11/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormMapElement.h"
#import "MYSFormTheme.h"


@implementation MYSFormMapElement

+ (instancetype)mapElementWithDisplayRegion:(MKCoordinateRegion)region
{
    MYSFormMapElement *element = [self new];
    element.region = region;
    return element;
}

+ (double)coordinatesForMiles:(CGFloat)miles
{
    return 0.0144927536 * miles;
}

- (void)configureClassDefaultTheme:(MYSFormTheme *)theme
{
    theme.backgroundColor = [UIColor clearColor];
}

@end
