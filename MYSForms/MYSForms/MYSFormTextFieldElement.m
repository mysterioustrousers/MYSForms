//
//  MYSFormTextFieldElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextFieldElement.h"
#import "MYSFormTextFieldCell-Private.h"


@interface MYSFormTextFieldElement () <MYSFormTextFieldCellDelegate>
@end


@implementation MYSFormTextFieldElement

+ (instancetype)textFieldElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormTextFieldElement *element    = [self new];
    element.label                       = label;
    element.modelKeyPath                = modelKeyPath;
    element.secure                      = NO;
    element.keyboardType                = UIKeyboardTypeDefault;
    return element;
}

- (BOOL)isTextInput
{
    return YES;
}

- (BOOL)isEditable
{
    return YES;
}

- (void)beginEditing
{
    [[self.cell textInput] becomeFirstResponder];
}

- (void)setCell:(MYSFormTextFieldCell *)cell
{
    [super setCell:cell];
    cell.textFieldCellDelegate = self;
}


#pragma mark - DELEGATE text field cell

- (void)textFormCell:(MYSFormTextFieldCell *)cell textDidChange:(NSString *)text
{
    [self.delegate formElement:self valueDidChange:text];
}

@end
