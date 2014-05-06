//
//  MYSEditFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSValidationFormViewController.h"
#import "MYSExampleUser.h"


@implementation MYSValidationFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [MYSExampleUser new];
}

- (void)configureForm
{
    [super configureForm];

    MYSFormHeadlineElement *title = [MYSFormHeadlineElement headlineFormElementWithHeadline:@"Edit User"];
    [self addFormElement:title];

    MYSFormFootnoteElement *description = [MYSFormFootnoteElement new];
    description.footnote = @"Example of a form that utilizes validations.";
    [self addFormElement:description];

    MYSFormTextFieldElement *firstNameField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    [firstNameField addFormValidation:[MYSFormPresenceValidation new]];
    [self addFormElement:firstNameField];

    MYSFormTextFieldElement *lastNameField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"Last Name" modelKeyPath:@"lastName"];
    [lastNameField addFormValidation:[MYSFormPresenceValidation new]];
    [self addFormElement:lastNameField];

    MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"E-mail" modelKeyPath:@"email"];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailField addFormValidation:[MYSFormPresenceValidation new]];
    [emailField addFormValidation:[MYSFormRegexValidation regexValidationWithName:MYSFormRegexValidationPatternEmail]];
    [self addFormElement:emailField];

    MYSFormButtonElement *validateButton = [MYSFormButtonElement buttonFormElementWithTitle:@"Validate"
                                                                                     target:self
                                                                                     action:@selector(validateForm:)];
    [self addFormElement:validateButton];
}




#pragma mark - Actions

- (void)validateForm:(id)sender
{
    if ([self validate]) {
        NSLog(@"Valid!");
    }
    else {
        NSLog(@"Not Valid!");
    }
}

@end
