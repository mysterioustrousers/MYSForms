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
        MYSFormViewController *formViewController = [MYSFormViewController new];

        formViewController.view.backgroundColor = [UIColor whiteColor];

        // setting the model before configuration
        formViewController.model = self.fakeUser;

        MYSFormLabelElement *headline = [MYSFormLabelElement labelElementWithText:@"Log In"];
        headline.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [formViewController addFormElement:headline];


        MYSFormLabelElement *footnote = [MYSFormLabelElement new];
        footnote.label = @"An example form that does not subclass the form view controller. It just creates one, configures and displays it.";
        footnote.theme = [MYSFormTheme formThemeWithLabelFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
        [formViewController addFormElement:footnote];


        MYSFormTextFieldElement *emailField = [MYSFormTextFieldElement textFieldElementWithLabel:@"E-mail" modelKeyPath:@"email"];
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
        [formViewController addFormElement:emailField];


        MYSFormTextFieldElement *passwordField = [MYSFormTextFieldElement textFieldElementWithLabel:@"Password" modelKeyPath:@"password"];
        passwordField.secure = YES;
        [formViewController addFormElement:passwordField];


        [formViewController addFormElement:[MYSFormLabelAndButtonElement labelAndButtonElementWithLabel:@"A label"
                                                                                                 button:[MYSFormButton formButtonWithTitle:@"A button title"
                                                                                                                                     style:MYSFormButtonStyleDefault
                                                                                                                                    action:^(MYSFormElement *element)
        {
            NSLog(@"Label and button was tapped");
        }]]];

        MYSFormButton *leftButton = [MYSFormButton formButtonWithTitle:@"Left Button"
                                                                 style:MYSFormButtonStyleDefault
                                                                action:^(MYSFormElement *element)
        {
            NSLog(@"Left button pressed");
        }];

        MYSFormButton *rightButton = [MYSFormButton formButtonWithTitle:@"Right Button"
                                                                  style:MYSFormButtonStyleDefault
                                                                 action:^(MYSFormElement *element)
        {
            NSLog(@"Rigth button pressed");
        }];

        [formViewController addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[leftButton, rightButton]]];


        MYSFormButton *button1 = [MYSFormButton formButtonWithTitle:@"Button 1"
                                                              style:MYSFormButtonStyleDefault
                                                             action:^(MYSFormElement *element)
        {
            NSLog(@"button 1 pressed");
        }];

        MYSFormButton *button2 = [MYSFormButton formButtonWithTitle:@"Button 2"
                                                              style:MYSFormButtonStyleBordered
                                                             action:^(MYSFormElement *element)
        {
            NSLog(@"button 2 pressed");
        }];

        MYSFormButton *button3 = [MYSFormButton formButtonWithTitle:@"Button 3"
                                                              style:MYSFormButtonStyleFilled
                                                             action:^(MYSFormElement *element)
        {
            NSLog(@"button 3 pressed");
        }];

        [formViewController addFormElement:[MYSFormButtonElement buttonElementWithButtons:@[button1, button2, button3]]];


        formViewController.formDelegate = self;
        
        [self.navigationController pushViewController:formViewController animated:YES];

        formViewController.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
    }
}

@end
