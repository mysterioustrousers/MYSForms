//
//  MYSFormLoadingCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLoadingCell.h"
#import "MYSFormMessageElement.h"


static CGFloat spinnerSize      = 20;
static CGFloat standardSpacing  = 8;


@implementation MYSFormLoadingCell

+ (CGSize)sizeRequiredForElement:(MYSFormMessageElement *)element width:(CGFloat)width
{
    // subtract the cell margins
    width -= [self cellContentInset].left + [self cellContentInset].right;

    // subtract the spinner and spacing
    width -= spinnerSize + standardSpacing;
    
    CGSize size = [element.message boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{
                                                          NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
                                                          }
                                                context:nil].size;
    size.height = ceil(size.height);
    size.height = size.height >= spinnerSize ? size.height : spinnerSize;
    size.height += 20;
    return size;
}

@end
