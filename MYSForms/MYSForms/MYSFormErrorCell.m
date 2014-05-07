//
//  MYSFormErrorCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/5/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormErrorCell.h"
#import "MYSFormErrorElement.h"


@implementation MYSFormErrorCell

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.backgroundColor = [UIColor darkGrayColor];
//}

+ (CGSize)sizeRequiredForElement:(MYSFormErrorElement *)element width:(CGFloat)width
{
    width -= [self cellContentInset].left + [self cellContentInset].right;
    CGSize size = [element.error boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
                                                            }
                                                  context:nil].size;
    size.height = ceil(size.height);
    return size;
}

- (void)populateWithElement:(MYSFormErrorElement *)element
{
    self.errorLabel.text = element.error;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGPoint point1 = CGPointMake(15, self.frame.size.height / 2.0);
    CGPoint point2 = CGPointMake(10, point1.y);
    CGPoint point3 = CGPointMake(point2.x, 0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [[UIColor colorWithRed:(215.0/255.0) green:0 blue:0 alpha:1] setStroke];
    [path stroke];
}

@end
