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

    [self addFormElement:[MYSFormHeadlineElement headlineElementWithHeadline:@"Edit User"]];

    [self addFormElement:[MYSFormFootnoteElement footnoteElementWithFootnote:@"Example of a form that utilizes validations."]];


    MYSFormTextFieldElement *firstNameField = [MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    [firstNameField addFormValidation:[MYSFormPresenceValidation new]];
    [self addFormElement:firstNameField];


    MYSFormTextFieldElement *lastNameField = [MYSFormTextFieldElement textFieldElementWithLabel:@"Last Name" modelKeyPath:@"lastName"];
    [lastNameField addFormValidation:[MYSFormPresenceValidation new]];
    [self addFormElement:lastNameField];


    MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldElementWithLabel:@"E-mail" modelKeyPath:@"email"];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailField addFormValidation:[MYSFormPresenceValidation new]];
    [emailField addFormValidation:[MYSFormRegexValidation regexValidationWithName:MYSFormRegexValidationPatternEmail]];
    [self addFormElement:emailField];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Validate" action:^(MYSFormElement *element) {
        if ([self validate]) {
            NSLog(@"Valid!");
        }
        else {
            NSLog(@"Not Valid!");
        }
    }]]]];
}

@end
