//
//  MYSLoadingViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSLoadingViewController.h"


@interface MYSLoadingViewController ()
@property (nonatomic, strong) MYSFormElement *firstNameElement;
@property (nonatomic, strong) MYSFormElement *loadButtonElement;
@end


@implementation MYSLoadingViewController

- (void)configureForm
{
    [super configureForm];


    [self addFormElement:[MYSFormHeadlineElement headlineElementWithHeadline:@"Edit User"]];


    [self addFormElement:[MYSFormFootnoteElement footnoteElementWithFootnote:@"Example of a form that utilizes the built-in loading mechanism on form elements. Dismisses after 4 seconds."]];


    self.firstNameElement = [MYSFormTextFieldElement textFieldElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    self.firstNameElement.loadingMessage = @"Loading for a specific form element.";
    [self addFormElement:self.firstNameElement];


    self.loadButtonElement = [MYSFormButtonElement buttonElementWithTitle:@"Show Loading" block:^(MYSFormElement *element) {
        [self showLoadingForElements:@[self.loadButtonElement]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingForElements:nil];
        });
    }];
    self.loadButtonElement.loadingMessage = @"This is a loading message added to Show Loading button";
    [self addFormElement:self.loadButtonElement];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Show Loading Specific" block:^(MYSFormElement *element) {
        [self showLoadingForElements:@[self.firstNameElement]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingForElements:nil];
        });
    }]];


    MYSFormButtonElement *button =
    [MYSFormButtonElement buttonElementWithTitle:@"Hide Loading Specific" block:^(MYSFormElement *element) {
        [self showLoadingForElements:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingForElements:@[self.firstNameElement, self.loadButtonElement]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideLoadingForElements:nil];
            });
        });
    }];
    button.loadingMessage = @"This will show loading for all elements that have a loadingMessage value set, but stop all but one element after 4 seconds. And then all after 6 seconds.";
    [self addFormElement:button];
}


@end
