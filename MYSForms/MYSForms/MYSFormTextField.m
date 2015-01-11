//
//  MYSFormTextField.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextField.h"

@implementation MYSFormTextField

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat y = ceil(CGRectGetMaxY(self.bounds)) - 1;
    [path moveToPoint:CGPointMake(0, y)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, y)];
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
}

@end
