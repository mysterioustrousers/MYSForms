//
//  MYSFormToggleElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormToggleElement.h"
#import "MYSFormToggleCell-Private.h"


@interface MYSFormToggleElement () <MYSFormToggleCellDelegate>
@end


@implementation MYSFormToggleElement

+ (instancetype)toggleElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath;
{
    MYSFormToggleElement *element   = [self new];
    element.label                   = label;
    element.modelKeyPath            = modelKeyPath;
    return element;
}

- (void)setCell:(MYSFormToggleCell *)cell
{
    [super setCell:cell];
    cell.toggleCellDelegate = self;
}

- (BOOL)isEditable
{
    return YES;
}


#pragma mark - DELEGATE toggle cell

- (void)toggleCell:(MYSFormToggleCell *)cell didToggleOn:(BOOL)isOn
{
    [self.delegate formElement:self valueDidChange:@(isOn)];
}

@end
