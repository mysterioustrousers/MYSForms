//
//  MYSTableViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSTableViewController.h"
#import "MYSFormViewController.h"
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




#pragma mark - Actions

- (void)logModelValues:(id)sender
{
    NSLog(@"Current Model: %@", self.fakeUser);
}




#pragma mark - DELEGATE form view controller

- (void)formViewControllerDidSubmit:(MYSFormViewController *)controller
{
    [self logModelValues:nil];
}




#pragma mark - DELEGATE table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // log in form
    if (indexPath.row == 0) {
        MYSFormViewController *formViewController = [MYSFormViewController new];

        // setting the model before configuration
        formViewController.model = self.fakeUser;

        MYSFormHeadlineElement *headline = [MYSFormHeadlineElement headlineFormElementWithHeadline:@"Log In"];
        [formViewController addFormElement:headline];


        MYSFormFootnoteElement *footnote = [MYSFormFootnoteElement new];
        footnote.footnote = @"An example form that does not subclass the form view controller. It just creates one, configures and displays it.";
        [formViewController addFormElement:footnote];

        MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"E-mail" modelKeyPath:@"email"];
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
        [formViewController addFormElement:emailField];

        MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"Password" modelKeyPath:@"password"];
        passwordField.secure = YES;
        [formViewController addFormElement:passwordField];

        MYSFormButtonElement *logInButton = [MYSFormButtonElement buttonFormElementWithTitle:@"Log Model Values"
                                                                                   target:self
                                                                                   action:@selector(logModelValues:)];
        [formViewController addFormElement:logInButton];

        formViewController.formDelegate = self;
        
        [self.navigationController pushViewController:formViewController animated:YES];
    }
}


@end
