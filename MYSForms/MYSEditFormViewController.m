//
//  MYSEditFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSEditFormViewController.h"


@interface MYSEditFormViewController ()
@end


@implementation MYSEditFormViewController

- (void)configureForm
{
    [super configureForm];

    MYSFormHeadlineElement *title = [MYSFormHeadlineElement headlineFormElementWithHeadline:@"Edit User"];
    [self addFormElement:title];

    MYSFormFootnoteElement *description = [MYSFormFootnoteElement new];
    description.footnote = @"This form demonstrates a how setEditing: works with MYSForms.";
    [self addFormElement:description];

    MYSFormTextFieldElement *firstNameField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    [self addFormElement:firstNameField];

    MYSFormTextFieldElement *lastNameField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"Last Name" modelKeyPath:@"lastName"];
    [self addFormElement:lastNameField];

    MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"E-mail" modelKeyPath:@"email"];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [self addFormElement:emailField];

    MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"Password" modelKeyPath:@"password"];
    passwordField.secure = YES;
    [self addFormElement:passwordField];

    [self setEditing:NO];
}

@end
