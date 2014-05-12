//
//  MYSFormButton.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButton.h"


@implementation MYSFormButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.borderColor  = self.tintColor.CGColor;
    self.layer.borderWidth  = 1;
    self.layer.cornerRadius = 10;
}

- (CGSize) intrinsicContentSize {

    CGSize s = [super intrinsicContentSize];

    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}

@end
