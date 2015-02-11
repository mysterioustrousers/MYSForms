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
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
}

- (void)configureForm
{
    [super configureForm];

    MYSFormLabelElement *headlineElement = [MYSFormLabelElement labelElementWithText:@"Sign Up"];
    headlineElement.theme.labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self addFormElement:headlineElement];

    MYSFormLabelElement *footnoteElement = [MYSFormLabelElement labelElementWithText:@"Example of a subclassed form view controller where a blank model is created in its viewDidLoad."];
    footnoteElement.theme.labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    footnoteElement.theme.padding = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(5, 0, 10, 0)];
    [self addFormElement:footnoteElement];

    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"]];

    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"Last Name" modelKeyPath:@"lastName"]];


    MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldElementWithLabel:@"E-mail" modelKeyPath:@"email"];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [self addFormElement:emailField];


    MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldElementWithLabel:@"Password" modelKeyPath:@"password"];
    passwordField.secure = YES;
    [self addFormElement:passwordField];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Log Current Model"
                                                                                                       style:MYSFormButtonStyleDefault
                                                                                                      action:^(MYSFormElement *element)
    {
        NSLog(@"Current Model: %@", self.model);
    }]]]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Set Random Data On Model"
                                                                                                       style:MYSFormButtonStyleDefault
                                                                                                      action:^(MYSFormElement *element)
    {
        MYSExampleUser *user = self.model;
        user.firstName  = [self randomStringWithLength:10];
        user.lastName   = [self randomStringWithLength:10];
        user.email      = [self randomStringWithLength:10];
        user.password   = [self randomStringWithLength:10];
    }]]]];
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
