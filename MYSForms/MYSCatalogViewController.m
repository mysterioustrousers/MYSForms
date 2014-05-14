//
//  MYSCatalogViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSCatalogViewController.h"
#import "MYSExampleUser.h"


@interface MYSCatalogViewController ()
@end


@implementation MYSCatalogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [MYSExampleUser new];
    MYSExampleUser *exampleUser = self.model;
    exampleUser.yearsOld = 10;
}

- (void)configureForm
{
    [super configureForm];


    [self addFormElement:[MYSFormHeadlineElement headlineElementWithHeadline:@"A Headline"]];


    [self addFormElement:[MYSFormFootnoteElement footnoteElementWithFootnote:
                          @"A footnote/description element for offering a more detailed explanation in your form."]];


    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"Text Field" modelKeyPath:@"firstName"]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Button" block:^(MYSFormElement *element) {
        [self showSuccessMessage:@"A success message." belowElement:element duration:3 completion:nil];
        [self logModel];
    }]];

    [self addFormElement:[MYSFormLabelAndButtonElement buttonElementWithLabel:@"A label" title:@"And button" block:^(MYSFormButtonElement *element) {
        [self showErrorMessage:@"An error message." belowElement:element duration:3 completion:nil];
    }]];

    [self addFormElement:[MYSFormImagePickerElement imagePickerElementWithLabel:@"Selfie" modelKeyPath:nil]];

    MYSFormPickerElement *pickerElement = [MYSFormPickerElement pickerElementWithLabel:@"Age" modelKeyPath:@"yearsOld"];
    pickerElement.valueTransformer = [MYSFormNumberToStringValueTransformer new];
    for (NSInteger i = 0; i < 120; i++) {
        [pickerElement addValue:@(i)];
    }
    [self addFormElement:pickerElement];
}




#pragma mark - Actions

- (void)logModel
{
    NSLog(@"%@", self.model);
}

@end
