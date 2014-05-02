//
//  MYSInputAccessoryView.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSInputAccessoryView.h"

@implementation MYSInputAccessoryView

+ (instancetype)accessoryViewWithDelegate:(id<MYSInputAccessoryViewDelegate>)delegate
{
    UINib *nib                                  = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    NSArray *objects                            = [nib instantiateWithOwner:delegate options:nil];
    MYSInputAccessoryView *inputAccessoryView   = [objects lastObject];
    inputAccessoryView.delegate                 = delegate;
    return inputAccessoryView;
}

- (IBAction)previousButtonWasTapped:(id)sender
{
    [self.delegate accessoryInputView:self didPressPreviousButton:sender];
}

- (IBAction)nextButtonWasTapped:(id)sender
{
    [self.delegate accessoryInputView:self didPressNextButton:sender];
}

- (IBAction)dismissButtonWasTapped:(id)sender
{
    [self.delegate accessoryInputView:self didPressDismissButton:sender];
}



@end
