//
//  MYSTableViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSTableViewController.h"
#import "MYSForms.h"
#import "MYSSignUpFormViewController.h"

// test models
#import "MYSExampleUser.h"


@interface MYSTableViewController () <MYSFormViewControllerDelegate>
@property (nonatomic, strong) MYSExampleUser *fakeUser;
@end


@implementation MYSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fakeUser = [MYSExampleUser new];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignUpFormSegue"]) {
        MYSSignUpFormViewController *signUpFormViewController = [segue destinationViewController];
        signUpFormViewController.formDelegate = self;
        // model is created in viewDidLoad of sign up vc
    }
}




#pragma mark - DELEGATE form view controller

- (void)formViewControllerDidSubmit:(MYSFormViewController *)controller
{
    NSLog(@"Current Model: %@", self.fakeUser);
}




#pragma mark - DELEGATE table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // log in form
    if (indexPath.row == 0) {
        MYSSlideFormViewController *formViewController = [MYSSlideFormViewController new];

        // setting the model before configuration
        formViewController.model = self.fakeUser;

        MYSFormHeadlineElement *headline = [MYSFormHeadlineElement headlineElementWithHeadline:@"Log In"];
        [formViewController addFormElement:headline];


        MYSFormFootnoteElement *footnote = [MYSFormFootnoteElement new];
        footnote.footnote = @"An example form that does not subclass the form view controller. It just creates one, configures and displays it.";
        [formViewController addFormElement:footnote];


        MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldElementWithLabel:@"E-mail" modelKeyPath:@"email"];
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
        [formViewController addFormElement:emailField];


        MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldElementWithLabel:@"Password" modelKeyPath:@"password"];
        passwordField.secure = YES;
        [formViewController addFormElement:passwordField];


        [formViewController addFormElement:[MYSFormLabelAndButtonElement buttonElementWithLabel:@"A label" title:@"A button title" block:^(MYSFormButtonElement *element) {
            NSLog(@"Label and button was tapped");
        }]];


        [formViewController addFormElement:[MYSFormButtonElement buttonElementWithTitle:@"Log Model Values" block:^(MYSFormButtonElement *element) {
            NSLog(@"Current Model: %@", self.fakeUser);
        }]];


        formViewController.formDelegate = self;
        
        [self.navigationController pushViewController:formViewController animated:YES];
    }
}


@end
