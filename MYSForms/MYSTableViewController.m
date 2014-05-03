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
//        MYSFakeUser *user = [MYSFakeUser new];
//        MYSFormCollectionView *formViewController = [MYSFormCollectionView formViewControllerWithModel:user];
//        [formViewController addHeadlineElementWithString:@"Log In"];
//        [formViewController addFootnoteElementWithString:@"A table view displays a list of items in a single column. UITableView is a subclass of UIScrollView."];
//        [formViewController addTextInputElementWithModelKeyPath:@"email"
//                                                          label:@"E-mail"
//                                                   keyboardType:UIKeyboardTypeEmailAddress
//                                                         secure:NO];
//        [formViewController addTextInputElementWithModelKeyPath:@"password"
//                                                          label:@"Password"
//                                                   keyboardType:UIKeyboardTypeDefault
//                                                         secure:YES];
//        [formViewController addButtonElementWithTitle:@"Log In" target:self action:@selector(logInButtonWasTapped:)];
    }

}






@end
