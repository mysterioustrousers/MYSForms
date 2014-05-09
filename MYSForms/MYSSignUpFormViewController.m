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


    MYSFormHeadlineElement *title = [MYSFormHeadlineElement headlineElementWithHeadline:@"Sign Up"];
    [self addFormElement:title];


    MYSFormFootnoteElement *description = [MYSFormFootnoteElement new];
    description.footnote = @"Example of a subclassed form view controller where a blank model is created in its viewDidLoad.";
    [self addFormElement:description];


    MYSFormTextFieldElement *firstNameField = [MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    [self addFormElement:firstNameField];


    MYSFormTextFieldElement *lastNameField = [MYSFormTextFieldElement textFieldElementWithLabel:@"Last Name" modelKeyPath:@"lastName"];
    [self addFormElement:lastNameField];


    MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldElementWithLabel:@"E-mail" modelKeyPath:@"email"];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [self addFormElement:emailField];


    MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldElementWithLabel:@"Password" modelKeyPath:@"password"];
    passwordField.secure = YES;
    [self addFormElement:passwordField];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Log Current Model" block:^(MYSFormButtonElement *element) {
        NSLog(@"Current Model: %@", self.model);
    }]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Set Random Data On Model" block:^(MYSFormButtonElement *element) {
        MYSExampleUser *user = self.model;
        user.firstName  = [self randomStringWithLength:10];
        user.lastName   = [self randomStringWithLength:10];
        user.email      = [self randomStringWithLength:10];
        user.password   = [self randomStringWithLength:10];
    }]];
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
