//
//  MYSFormButton.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButton.h"


@implementation MYSFormButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.borderColor  = self.tintColor.CGColor;
    self.layer.borderWidth  = 1;
    self.layer.cornerRadius = 10;
}

@end
