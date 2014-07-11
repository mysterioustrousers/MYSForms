//
//  MYSFormSlideViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 6/6/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormSlideViewController.h"


@interface MYSFormSlideViewController ()
@property (nonatomic, assign, readwrite) BOOL appearedFirstTime;
@end


@implementation MYSFormSlideViewController

- (void)formInit
{
    [super formInit];
    self.appearedFirstTime = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.appearedFirstTime) {
        UIEdgeInsets insets = self.collectionView.contentInset;
        insets.top += self.collectionView.bounds.size.height;
        self.collectionView.contentInset = insets;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.appearedFirstTime && [self shouldSlideInAutomatically]) {
        [self slideInWithCompletion:^{
            if (self.isEditing) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[[self visibleTextInputs] firstObject] becomeFirstResponder];
                });
            }
        }];
    }
}




#pragma mark - Public

- (BOOL)shouldSlideInAutomatically
{
    return YES;
}

- (void)slideInWithCompletion:(void (^)(void))completion;
{
    if (self.appearedFirstTime) return;
    self.appearedFirstTime = YES;
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top -= self.collectionView.bounds.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.contentInset = insets;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}


@end
