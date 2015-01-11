//
//  MYSLoadingViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSLoadingFormViewController.h"


@interface MYSLoadingFormViewController ()
@property (nonatomic, strong) MYSFormElement *firstNameElement;
@property (nonatomic, strong) MYSFormElement *loadButtonElement;
@end


@implementation MYSLoadingFormViewController

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


    MYSFormLabelElement *footnoteElement = [MYSFormLabelElement labelElementWithText:@"Example of a form that utilizes the built-in loading mechanism on form elements. Dismisses after 4 seconds."];
    footnoteElement.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self addFormElement:footnoteElement];


    self.firstNameElement = [MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
//    self.firstNameElement.loadingMessage = ;
    [self addFormElement:self.firstNameElement];


    self.loadButtonElement = [MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Show Loading" action:^(MYSFormElement *element) {
        [self showLoadingMessage:@"This is a loading message added to Show Loading button" aboveElement:self.loadButtonElement completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingAboveElement:self.loadButtonElement completion:nil];
        });
    }]]];
    [self addFormElement:self.loadButtonElement];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Show Loading Specific" action:^(MYSFormElement *element) {
        [self showLoadingMessage:@"Loading for a specific form element." aboveElement:self.firstNameElement completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingAboveElement:self.firstNameElement completion:nil];
        });
    }]]]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Hide Loading Specific" action:^(MYSFormElement *element) {
        [self showLoadingMessage:@"This will show loading for 2 elements, stop one element after 4 seconds. And then all after 6 seconds."
                    aboveElement:self.loadButtonElement
                      completion:nil];
        [self showLoadingMessage:@"Here is the second loading message. This one will go first."
                    aboveElement:self.firstNameElement
                      completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingAboveElement:self.firstNameElement completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideLoadingAboveElement:self.loadButtonElement completion:nil];
            });
        });
    }]]]];
}


@end
