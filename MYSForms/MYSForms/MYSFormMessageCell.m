//
//  MYSFormErrorCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/9/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormMessageCell.h"
#import "MYSFormMessageElement.h"


#define RED     [UIColor colorWithRed:(215.0/255.0) green:0 blue:0 alpha:1]
#define GREEN   [UIColor colorWithRed:0 green:(215.0/255.0) blue:0 alpha:1]


@interface MYSFormMessageCell ()
@property (nonatomic, weak) MYSFormMessageElement *element;
@end


@implementation MYSFormMessageCell

+ (CGSize)sizeRequiredForElement:(MYSFormMessageElement *)element width:(CGFloat)width
{
    width -= [self cellContentInset].left + [self cellContentInset].right - 5;
    CGSize size = [element.message boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{
                                                          NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
                                                          }
                                                context:nil].size;
    size.height = ceil(size.height);

    // some padding
    if (element.type != MYSFormMessageTypeValidationError) {
        size.height += 20;
    }

    return size;
}

- (void)populateWithElement:(MYSFormMessageElement *)element
{
    self.element = element;
    self.messageLabel.text = element.message;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.element.type == MYSFormMessageTypeError) {
        self.messageLabel.textColor = RED;
    }
    else if (self.element.type == MYSFormMessageTypeValidationError) {
        self.messageLabel.textColor = RED;
    }
    else if (self.element.type == MYSFormMessageTypeSuccess) {
        self.messageLabel.textColor = GREEN;
    }
    else {
        self.messageLabel.textColor = [UIColor blackColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.element.type == MYSFormMessageTypeError) {
        CGPoint point1 = CGPointMake(20, (self.frame.size.height / 2.0) - 5);
        CGPoint point2 = CGPointMake(30, (self.frame.size.height / 2.0) + 5);
        CGPoint point3 = CGPointMake(20, (self.frame.size.height / 2.0) + 5);
        CGPoint point4 = CGPointMake(30, (self.frame.size.height / 2.0) - 5);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        [path moveToPoint:point3];
        [path addLineToPoint:point4];
        [RED setStroke];
        [path stroke];
    }
    else if (self.element.type == MYSFormMessageTypeValidationError) {
        CGPoint point1 = CGPointMake(25, self.frame.size.height / 2.0);
        CGPoint point2 = CGPointMake(20, point1.y);
        CGPoint point3 = CGPointMake(point2.x, 0);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
        [RED setStroke];
        [path stroke];
    }
    else if (self.element.type == MYSFormMessageTypeSuccess) {
        CGPoint point1 = CGPointMake(22, (self.frame.size.height / 2.0));
        CGPoint point2 = CGPointMake(point1.x + 4, point1.y + 5);
        CGPoint point3 = CGPointMake(point2.x + 4, point2.y - 12);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
        [GREEN setStroke];
        [path stroke];
    }
}

@end
