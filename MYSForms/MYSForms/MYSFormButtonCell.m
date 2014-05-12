//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonCell.h"
#import "MYSFormButtonElement.h"
#import "private.h"


@implementation MYSFormButtonCell

- (void)populateWithElement:(MYSFormButtonElement *)element
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.button setTitle:element.title forState:UIControlStateNormal];
        [self.button layoutIfNeeded];
    }];
}




#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.buttonCellDelegate formButtonCell:self didTapButton:sender];
}

@end
