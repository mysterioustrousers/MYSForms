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

    MYSFormHeadlineElement *title = [MYSFormHeadlineElement headlineFormElementWithHeadline:@"Edit User"];
    [self addFormElement:title];

    MYSFormFootnoteElement *description = [MYSFormFootnoteElement new];
    description.footnote = @"Example of a form that utilizes the built-in loading mechanism on form elements. Dismisses after 4 seconds.";
    [self addFormElement:description];

    MYSFormTextFieldElement *firstNameField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"First Name" modelKeyPath:@"firstName"];
    firstNameField.loadingMessage = @"Loading for a specific form element.";
    [self addFormElement:firstNameField];
    self.firstNameElement = firstNameField;

    MYSFormButtonElement *loadButton = [MYSFormButtonElement buttonFormElementWithTitle:@"Show Loading"
                                                                                     target:self
                                                                                     action:@selector(startLoading:)];
    loadButton.loadingMessage = @"This is a loading message added to Show Loading button";
    [self addFormElement:loadButton];
    self.loadButtonElement = loadButton;

    MYSFormButtonElement *loadSpecificElement = [MYSFormButtonElement buttonFormElementWithTitle:@"Show Loading Specific"
                                                                                     target:self
                                                                                     action:@selector(showLoadingByFirstName:)];
    [self addFormElement:loadSpecificElement];

    MYSFormButtonElement *hideSpecificElement = [MYSFormButtonElement buttonFormElementWithTitle:@"Hide Loading Specific"
                                                                                     target:self
                                                                                     action:@selector(loadAllAndStopOne:)];
    hideSpecificElement.loadingMessage = @"This will show loading for all elements that have a loadingMessage value set, but stop all but one element after 4 seconds. And then all after 6 seconds.";
    [self addFormElement:hideSpecificElement];
}




#pragma mark - Actions

- (void)startLoading:(id)sender
{
    [self showLoadingForElements:@[self.loadButtonElement]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingForElements:nil];
    });
}

- (void)showLoadingByFirstName:(id)sender
{
    [self showLoadingForElements:@[self.firstNameElement]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingForElements:nil];
    });
}

- (void)loadAllAndStopOne:(id)sender
{
    [self showLoadingForElements:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingForElements:@[self.firstNameElement, self.loadButtonElement]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoadingForElements:nil];
        });
    });
}

@end
