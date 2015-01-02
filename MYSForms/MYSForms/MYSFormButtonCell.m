//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonCell.h"
#import "MYSFormButtonElement.h"


@interface MYSFormButtonCell ()
@property (nonatomic, copy) NSArray *buttons;
@end


@implementation MYSFormButtonCell

- (void)populateWithElement:(MYSFormButtonElement *)element
{
    for (MYSFormButton *button in self.buttons) {
        [button removeFromSuperview];
        if ([[button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] == 0) {
            [button removeTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    self.buttons = element.buttons;

    for (MYSFormButton *button in element.buttons) {
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.enabled = element.isEnabled;
    }
    [super populateWithElement:element];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIEdgeInsets insets = [[self class] cellContentInset];
    CGFloat buttonSpacing = (self.buttonSpacing ?: 8);
    CGFloat totalButtonSpace = self.bounds.size.width - insets.left - insets.right;
    NSInteger buttonCount = [self.buttons count];
    CGFloat buttonWidth = ((totalButtonSpace - (buttonCount - 1) * buttonSpacing) / [self.buttons count]);
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button setTitleColor:[self tintColor] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        frame.size.width = buttonWidth;
        frame.size.height = self.frame.size.height - insets.top - insets.bottom;
        frame.origin.x = insets.left + (buttonWidth + buttonSpacing) * idx;
        frame.origin.y = insets.top;
        button.frame = frame;
    }];
}


#pragma mark - Actions

- (IBAction)buttonWasTapped:(id)sender
{
    [self.buttonCellDelegate formButtonCell:self didTapButton:sender];
}

@end
