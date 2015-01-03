//
//  MYSFormHeadlineElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormHeadlineCell.h"
#import "MYSFormHeadlineElement.h"


@implementation MYSFormHeadlineCell

+ (CGSize)sizeRequiredForElement:(MYSFormHeadlineElement *)element width:(CGFloat)width
{
    width -= [self cellContentInset].left + [self cellContentInset].right;
    CGSize size = [element.headline boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{
                                                           NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                           }
                                                 context:nil].size;
    size.height = ceil(size.height) + [self cellContentInset].top + [self cellContentInset].bottom;
    return size;
}

- (void)populateWithElement:(MYSFormHeadlineElement *)element
{
    self.headlineLabel.text = element.headline;
    [super populateWithElement:element];
}

@end