//
//  MYSFormCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"
#import "MYSFormElement.h"


@implementation MYSFormCell

+ (CGSize)sizeRequiredForElement:(MYSFormElement *)element width:(CGFloat)width
{
    return CGSizeMake(width, 50);
}

+ (UIEdgeInsets)cellContentInset
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
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

- (UIView *)textInput
{
    return nil;
}

- (void)didChangeValueAtValueKeyPath
{

}

@end
