//
//  MYSSignUpFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSSignUpFormViewController.h"


@interface MYSSignUpFormViewController ()
@end


@implementation MYSSignUpFormViewController

- (void)configureForm
{
    [super configureForm];

    [self addHeadlineElementWithString:@"Sign Up"];

    [self addFootnoteElementWithString:@"A table view displays a list of items in a single column. UITableView is a subclass of UIScrollView."];

    [self addTextInputElementWithModelKeyPath:@"firstName"
                                        label:@"First Name"
                                 keyboardType:UIKeyboardTypeDefault
                                       secure:NO];

    [self addTextInputElementWithModelKeyPath:@"lastName"
                                        label:@"Last Name"
                                 keyboardType:UIKeyboardTypeDefault
                                       secure:NO];

    [self addTextInputElementWithModelKeyPath:@"email"
                                        label:@"E-mail"
                                 keyboardType:UIKeyboardTypeEmailAddress
                                       secure:NO];

    [self addTextInputElementWithModelKeyPath:@"password"
                                        label:@"Password"
                                 keyboardType:UIKeyboardTypeDefault
                                       secure:YES];

    [self addButtonElementWithTitle:@"Sign Up" target:self action:@selector(signUpButtonWasTapped:)];
}




#pragma mark - Actions

- (void)signUpButtonWasTapped:(id)sender
{
    NSLog(@"sign up button was tapped");
}

@end
