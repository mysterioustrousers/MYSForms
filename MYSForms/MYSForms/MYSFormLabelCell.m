//
//  MYSFormHeadlineElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLabelCell.h"
#import "MYSFormLabelElement.h"
#import "MYSFormTheme.h"


@implementation MYSFormLabelCell

+ (CGSize)sizeRequiredForElement:(MYSFormLabelElement *)element width:(CGFloat)width
{
    MYSFormTheme *theme = [element evaluatedTheme];
    UIEdgeInsets insets = [theme.contentInsets UIEdgeInsetsValue];
    width -= insets.left + insets.right;
    CGSize size = [element.label boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{
                                                           NSFontAttributeName : theme.labelFont
                                                           }
                                                 context:nil].size;
    size.height = ceil(size.height) + insets.top + insets.bottom;
    return size;
}

- (void)populateWithElement:(MYSFormLabelElement *)element
{
    self.label.text = element.label;
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.label.font = theme.labelFont;
    self.label.textColor = theme.labelTextColor;
}

@end