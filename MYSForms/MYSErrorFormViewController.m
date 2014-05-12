//
//  MYSErrorFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSErrorFormViewController.h"


@interface MYSErrorFormViewController ()
@property (nonatomic, strong) MYSFormElement *firstNameElement;
@property (nonatomic, strong) MYSFormElement *loadButtonElement;
@end


@implementation MYSErrorFormViewController

- (void)configureForm
{
    [super configureForm];


    [self addFormElement:[MYSFormHeadlineElement headlineElementWithHeadline:@"Edit User"]];


    [self addFormElement:[MYSFormFootnoteElement footnoteElementWithFootnote:
                          @"Example of a form that utilizes the built-in per-element error message functionality."]];


    self.firstNameElement = [MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    [self addFormElement:self.firstNameElement];


    self.loadButtonElement = [MYSFormButtonElement buttonElementWithTitle:@"Show Error" block:^(MYSFormElement *element) {
        [self showErrorMessage:@"An error message that shows for 4 seconds." belowElement:element duration:4 completion:nil];
    }];
    [self addFormElement:self.loadButtonElement];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Show Error Specific" block:^(MYSFormElement *element) {
        [self showErrorMessage:@"Error above a specific element for 3 seconds." belowElement:self.firstNameElement duration:3 completion:nil];
    }]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Show All Errors" block:^(MYSFormElement *element) {
        [self showErrorMessage:@"This error message will show for 5 seconds." belowElement:element duration:5 completion:nil];
        [self showErrorMessage:@"This error message will show for 3 seconds." belowElement:self.loadButtonElement duration:3 completion:nil];
        [self showErrorMessage:@"This error message will show for 6 seconds." belowElement:self.firstNameElement duration:6 completion:nil];
    }]];

    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Hide Error Early" block:^(MYSFormElement *element) {
        [self hideErrorMessageBelowElement:self.firstNameElement completion:nil];
    }]];

    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Show Success Message" block:^(MYSFormElement *element) {
        [self showSuccessMessage:@"A Success Message" belowElement:element duration:5 completion:nil];
    }]];
}

@end
