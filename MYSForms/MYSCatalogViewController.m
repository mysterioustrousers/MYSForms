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
    exampleUser.firstName = @"Adam";
    exampleUser.yearsOld = 10;
    exampleUser.isLegalAdult = YES;
    exampleUser.biography = @"Gozer the Traveler. He will come in one of the pre-chosen forms. During the rectification of the Vuldrini, the traveler came as a large and moving Torg! Then, during the third reconciliation of the last of the McKetrick supplicants, they chose a new form for him: that of a giant Slor! Many Shuvs and Zuuls knew what it was to be roasted in the depths of the Slor that day, I can tell you!";
}

- (void)configureForm
{
    [super configureForm];


    [self addFormElement:[MYSFormHeadlineElement headlineElementWithHeadline:@"A Headline"]];


    [self addFormElement:[MYSFormFootnoteElement footnoteElementWithFootnote:
                          @"A footnote/description element for offering a more detailed explanation in your form."]];


    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"Text Field" modelKeyPath:@"firstName"]];

    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"Text Field" modelKeyPath:@"lastName"]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Button" block:^(MYSFormElement *element) {
        [self showSuccessMessage:@"A success message." belowElement:element duration:3 completion:nil];
        [self logModel];
    }]];


    [self addFormElement:[MYSFormLabelAndButtonElement buttonElementWithLabel:@"A label" title:@"And button" block:^(MYSFormButtonElement *element) {
        [self showErrorMessage:@"An error message." belowElement:element duration:3 completion:nil];
    }]];


    [self addFormElement:[MYSFormImagePickerElement imagePickerElementWithLabel:@"Selfie" modelKeyPath:nil]];


    MYSFormPickerElement *pickerElement = [MYSFormPickerElement pickerElementWithLabel:@"Age" modelKeyPath:@"yearsOld"];
    pickerElement.valueTransformer = [MYSFormStringFromNumberValueTransformer new];
    for (NSInteger i = 0; i < 120; i++) {
        [pickerElement addValue:@(i)];
    }
    [self addFormElement:pickerElement];


    [self addFormElement:[MYSFormToggleElement toggleElementWithLabel:@"A toggle switch" modelKeyPath:@"isLegalAdult"]];


    MYSFormTextViewElement *textViewElement = [MYSFormTextViewElement textViewElementWithModelKeyPath:@"biography"];
    [textViewElement configureCellBlock:^(MYSFormCell *cell) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }];
    [self addFormElement:textViewElement];
}




#pragma mark - Actions

- (void)logModel
{
    NSLog(@"%@", self.model);
}

@end
