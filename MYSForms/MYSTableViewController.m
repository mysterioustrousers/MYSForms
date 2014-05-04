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
#import "MYSFakeUser.h"


@implementation MYSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"SignUpFormSegue"]) {
//        MYSSignUpFormViewController *signUpFormViewController = [segue destinationViewController];
//    }
}


#pragma mark - Actions

- (void)logInButtonWasTapped:(id)sender
{
    NSLog(@"Log in button was tapped");
}



#pragma mark - DELEGATE table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // log in form
    if (indexPath.row == 0) {
        MYSFakeUser *user = [MYSFakeUser new];
        MYSFormViewController *formViewController = [MYSFormViewController new];

        MYSFormHeadlineElement *headline = [MYSFormHeadlineElement headlineFormElementWithHeadline:@"Log In"];
        [formViewController addFormElement:headline];


        MYSFormFootnoteElement *footnote = [MYSFormFootnoteElement new];
        footnote.footnote = @"This is good for descriptions of what a form element is and what it means.";
        [formViewController addFormElement:footnote];

        MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"E-mail" modelKeyPath:@"email"];
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
        [formViewController addFormElement:emailField];

        MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldFormElementWithLabel:@"Password" modelKeyPath:@"password"];
        passwordField.secure = YES;
        [formViewController addFormElement:passwordField];

        MYSFormButtonElement *logInButton = [MYSFormButtonElement buttonFormElementWithTitle:@"Log In"
                                                                                   target:self
                                                                                   action:@selector(logInButtonWasTapped:)];
        [formViewController addFormElement:logInButton];

        [self.navigationController pushViewController:formViewController animated:YES];
    }

}






@end
