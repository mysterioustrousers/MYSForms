//
//  MYSSignUpFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSSignUpFormViewController.h"
#import "MYSExampleUser.h"


@implementation MYSSignUpFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [MYSExampleUser new];
}

- (void)configureForm
{
    [super configureForm];

    MYSFormHeadlineElement *title = [MYSFormHeadlineElement headlineFormElementWithHeadline:@"Sign Up"];
    [self addFormElement:title];

    MYSFormFootnoteElement *description = [MYSFormFootnoteElement new];
    description.footnote = @"Example of a subclassed form view controller where a blank model is created in its viewDidLoad.";
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

    MYSFormButtonElement *logButton = [MYSFormButtonElement buttonFormElementWithTitle:@"Log Current Model"
                                                                                   target:self
                                                                                   action:@selector(signUpButtonWasTapped:)];
    [self addFormElement:logButton];

    MYSFormButtonElement *randomButton = [MYSFormButtonElement buttonFormElementWithTitle:@"Set Random Data On Model"
                                                                                   target:self
                                                                                   action:@selector(setRandomWasTapped:)];
    [self addFormElement:randomButton];
}




#pragma mark - Actions

- (void)signUpButtonWasTapped:(id)sender
{
    NSLog(@"Current Model: %@", self.model);
}

- (void)setRandomWasTapped:(id)sender
{
    MYSExampleUser *user = self.model;
    user.firstName  = [self randomStringWithLength:10];
    user.lastName   = [self randomStringWithLength:10];
    user.email      = [self randomStringWithLength:10];
    user.password   = [self randomStringWithLength:10];
}




#pragma mark - Private

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

- (NSString *)randomStringWithLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];

    for (int i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }

    return randomString;
}


@end
