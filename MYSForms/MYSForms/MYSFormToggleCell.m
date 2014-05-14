//
//  MYSFormToggleCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormToggleCell.h"
#import "MYSFormToggleElement.h"
#import "MYSFormToggleCell-Private.h"


@implementation MYSFormToggleCell

- (void)populateWithElement:(MYSFormToggleElement *)element
{
    self.label.text = element.label;
    [super populateWithElement:element];
}




#pragma mark - Public

- (NSString *)valueKeyPath
{
    return @"toggleSwitch.on";
}




#pragma mark - Actions

- (IBAction)switchWasToggled:(UISwitch *)sender
{
    [self.toggleCellDelegate toggleCell:self didToggleOn:sender.isOn];
}

@end
