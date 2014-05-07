//
//  MYSFormLoadingCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLoadingCell.h"
#import "MYSFormLoadingElement.h"


static CGFloat spinnerSize      = 20;
static CGFloat standardSpacing  = 8;


@implementation MYSFormLoadingCell

+ (CGSize)sizeRequiredForElement:(MYSFormLoadingElement *)element width:(CGFloat)width
{
    // subtract the cell margins
    width -= [self cellContentInset].left + [self cellContentInset].right;

    // subtract the spinner and spacing
    width -= spinnerSize + standardSpacing;
    
    CGSize size = [element.parentFormElement.loadingMessage boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{
                                                                                   NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
                                                                                   }
                                                                         context:nil].size;
    size.height = ceil(size.height);
    size.height = size.height >= spinnerSize ? size.height : spinnerSize;
    return size;
}

- (void)populateWithElement:(MYSFormLoadingElement *)element
{
    self.loadingLabel.text = element.parentFormElement.loadingMessage;
}

@end
