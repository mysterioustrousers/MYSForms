//
//  MYSFormLoadingCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLoadingChildCell.h"
#import "MYSFormMessageChildElement.h"
#import "MYSFormTheme.h"


static CGFloat spinnerSize      = 20;
static CGFloat standardSpacing  = 8;


@implementation MYSFormLoadingChildCell

+ (CGSize)sizeRequiredForElement:(MYSFormMessageChildElement *)element width:(CGFloat)width
{
    MYSFormTheme *theme = [element evaluatedTheme];
    UIEdgeInsets insets = [theme.contentInsets UIEdgeInsetsValue];

    // subtract the cell margins
    width -= insets.left + insets.right;

    // subtract the spinner and spacing
    width -= spinnerSize + standardSpacing;
    
    CGSize size = [element.message boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{
                                                          NSFontAttributeName : theme.messageTextFont
                                                          }
                                                context:nil].size;
    size.height = ceil(size.height);
    size.height = size.height >= spinnerSize ? size.height : spinnerSize;
    size.height += 20;
    return size;
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.messageLabel.font      = theme.messageTextFont;
    self.messageLabel.textColor = theme.messageTextColor;
}

@end
