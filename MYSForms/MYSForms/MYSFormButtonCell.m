//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonCell.h"
#import "MYSFormButtonElement.h"


@implementation MYSFormButtonCell

- (void)populateWithElement:(MYSFormButtonElement *)element
{
    [self.button setTitle:element.title forState:UIControlStateNormal];
    [self.button addTarget:element.target action:element.action forControlEvents:UIControlEventTouchUpInside];
}

@end
