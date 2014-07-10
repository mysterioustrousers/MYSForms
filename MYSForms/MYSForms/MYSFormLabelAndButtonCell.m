//
//  MYSFormLabelAndButtonCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormLabelAndButtonCell.h"
#import "MYSFormLabelAndButtonElement.h"


@implementation MYSFormLabelAndButtonCell

- (void)populateWithElement:(MYSFormLabelAndButtonElement *)element
{
    self.label.text     = element.label;
    self.button.enabled = element.isEnabled;
    [super populateWithElement:element];
}

@end
