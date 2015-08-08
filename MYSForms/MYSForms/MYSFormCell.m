//
//  MYSFormCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"
#import "MYSFormElement.h"
#import "MYSFormTheme.h"


@implementation MYSFormCell

+ (CGSize)sizeRequiredForElement:(MYSFormElement *)element width:(CGFloat)width
{
    UIEdgeInsets insets = [[element evaluatedTheme].contentInsets UIEdgeInsetsValue];
    return CGSizeMake(width, insets.top + 44 + insets.bottom);
}

- (NSString *)valueKeyPath
{
    return nil;
}

- (void)populateWithElement:(MYSFormElement *)element
{
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    self.backgroundColor = theme.backgroundColor;
    self.tintColor = theme.tintColor;
}

- (UIView *)textInput
{
    return nil;
}

- (void)modelValueDidChange
{

}

@end
