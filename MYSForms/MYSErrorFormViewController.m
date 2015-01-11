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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
}

- (void)configureForm
{
    [super configureForm];


    MYSFormLabelElement *headlineElement = [MYSFormLabelElement labelElementWithText:@"Edit User"];
    headlineElement.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self addFormElement:headlineElement];


    MYSFormLabelElement *footnoteElement = [MYSFormLabelElement labelElementWithText:@"Example of a form that utilizes the built-in per-element error message functionality."];
    footnoteElement.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self addFormElement:footnoteElement];


    self.firstNameElement = [MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    [self addFormElement:self.firstNameElement];


    self.loadButtonElement = [MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Show Error"
                                                                                                           style:MYSFormButtonStyleDefault
                                                                                                          action:^(MYSFormElement *element)
    {
        [self showErrorMessage:@"An error message that shows for 4 seconds." belowElement:element duration:4 completion:nil];
    }]]];
    [self addFormElement:self.loadButtonElement];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Show Error Specific"
                                                                                                       style:MYSFormButtonStyleDefault
                                                                                                      action:^(MYSFormElement *element)
    {
        [self showErrorMessage:@"Error above a specific element for 3 seconds." belowElement:self.firstNameElement duration:3 completion:nil];
    }]]]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Show All Errors"
                                                                                                       style:MYSFormButtonStyleDefault
                                                                                                      action:^(MYSFormElement *element)
    {
        [self showErrorMessage:@"This error message will show for 5 seconds." belowElement:element duration:5 completion:nil];
        [self showErrorMessage:@"This error message will show for 3 seconds." belowElement:self.loadButtonElement duration:3 completion:nil];
        [self showErrorMessage:@"This error message will show for 6 seconds." belowElement:self.firstNameElement duration:6 completion:nil];
    }]]]];

    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Hide Error Early"
                                                                                                       style:MYSFormButtonStyleDefault
                                                                                                      action:^(MYSFormElement *element)
    {
        [self hideErrorMessageBelowElement:self.firstNameElement completion:nil];
    }]]]];

    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Show Success Message"
                                                                                                       style:MYSFormButtonStyleDefault
                                                                                                      action:^(MYSFormElement *element)
    {
        [self showSuccessMessage:@"A Success Message" belowElement:element duration:5 completion:nil];
    }]]]];
}

@end
