//
//  MYSThemeFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSThemeFormViewController.h"
#import "MYSExampleUser.h"


@implementation MYSThemeFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
    self.model = [MYSExampleUser new];
    MYSExampleUser *exampleUser = self.model;
    exampleUser.firstName = @"Adam";
    exampleUser.yearsOld = 10;
    exampleUser.birthDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 28];
    exampleUser.isLegalAdult = YES;
    exampleUser.biography = @"Gozer the Traveler. He will come in one of the pre-chosen forms. During the rectification of the Vuldrini, the traveler came as a large and moving Torg! Then, during the third reconciliation of the last of the McKetrick supplicants, they chose a new form for him: that of a giant Slor! Many Shuvs and Zuuls knew what it was to be roasted in the depths of the Slor that day, I can tell you!";
    exampleUser.tags = [NSOrderedSet orderedSetWithObjects:@"high priority", @"silly", @"a long tag name", @"blue", @"orange", nil];
}

- (void)configureForm
{
    [super configureForm];

    // set a form-wide theme
    self.theme = [MYSFormTheme new];
    self.theme.buttonStyle = @(MYSFormButtonStyleFilled);
    self.theme.buttonTitleFont = [UIFont fontWithName:@"Noteworthy" size:18];
    self.theme.labelFont = [UIFont fontWithName:@"Avenir" size:12];
    self.theme.inputTextFont = [UIFont fontWithName:@"Noteworthy" size:14];

    MYSFormLabelElement *headlineElement = [MYSFormLabelElement labelElementWithText:@"A Headline"];
    headlineElement.theme.labelFont = [UIFont fontWithName:@"Zapfino" size:26];
    [self addFormElement:headlineElement];

    MYSFormLabelElement *footnoteElement = [MYSFormLabelElement labelElementWithText:@"A footnote/description element for offering a more detailed explanation in your form."];
    footnoteElement.theme.labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    footnoteElement.theme.labelTextColor = [UIColor orangeColor];
    [self addFormElement:footnoteElement];


    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"Text Field" modelKeyPath:@"firstName"]];

    [self addFormElement:[MYSFormTextFieldElement textFieldElementWithLabel:@"Text Field" modelKeyPath:@"lastName"]];


    [self addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[[MYSFormButton formButtonWithTitle:@"Button" style:MYSFormButtonStyleNone action:^(MYSFormElement *element) {
        [self showSuccessMessage:@"A success message." belowElement:element duration:3 completion:nil];
    }]]]];


    [self addFormElement:[MYSFormLabelAndButtonElement labelAndButtonElementWithLabel:@"A label" button:[MYSFormButton formButtonWithTitle:@"A Button" style:MYSFormButtonStyleNone action:^(MYSFormElement *element) {
        [self showErrorMessage:@"An error message." belowElement:element duration:3 completion:nil];
    }]]];


    [self addFormElement:[MYSFormImagePickerElement imagePickerElementWithLabel:@"Selfie" modelKeyPath:nil]];

    MYSFormPickerElement *pickerElement = [MYSFormPickerElement pickerElementWithLabel:@"Age" modelKeyPath:@"yearsOld"];
    pickerElement.valueTransformer = [MYSFormStringFromNumberValueTransformer new];
    for (NSInteger i = 0; i < 120; i++) {
        [pickerElement addValue:@(i)];
    }
    [self addFormElement:pickerElement];


    MYSFormToggleElement *toggleElement = [MYSFormToggleElement toggleElementWithLabel:@"A toggle switch" modelKeyPath:@"isLegalAdult"];
    toggleElement.theme.toggleOnTintColor = [UIColor yellowColor];
    toggleElement.theme.toggleThumbTintColor = [UIColor blueColor];
    [self addFormElement:toggleElement];


    [self addFormElement:[MYSFormDatePickerElement datePickerElementWithLabel:@"Date Picker with a long title" modelKeyPath:@"birthDate"]];
}

@end
