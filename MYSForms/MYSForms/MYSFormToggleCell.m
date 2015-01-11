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
#import "MYSFormTheme.h"


@implementation MYSFormToggleCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.toggleSwitch.tintColor = self.tintColor;
}

- (void)populateWithElement:(MYSFormToggleElement *)element
{
    self.label.text           = element.label;
    self.toggleSwitch.enabled = element.isEnabled;
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.label.font                     = theme.labelFont;
    self.label.textColor                = theme.labelTextColor;
    self.toggleSwitch.onTintColor       = theme.toggleOnTintColor;
    self.toggleSwitch.thumbTintColor    = theme.toggleThumbTintColor;
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
