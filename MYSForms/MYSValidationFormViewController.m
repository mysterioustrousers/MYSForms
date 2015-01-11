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
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
}

- (void)configureForm
{
    [super configureForm];

    MYSFormLabelElement *headlineElement = [MYSFormLabelElement labelElementWithText:@"Edit User"];
    headlineElement.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self addFormElement:headlineElement];


    MYSFormLabelElement *footnoteElement = [MYSFormLabelElement labelElementWithText:@"Example of a form that utilizes validations."];
    footnoteElement.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self addFormElement:footnoteElement];


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
