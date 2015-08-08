//
//  MYSFormButton.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButton.h"


@implementation MYSFormButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        _buttonStyle = MYSFormButtonStyleNone;
    }
    return self;
}

+ (instancetype)formButtonWithTitle:(NSString *)title style:(MYSFormButtonStyle)style action:(MYSFormButtonActionBlock)action
{
    MYSFormButton *button = [self new];
    button.action = action;
    button.buttonStyle = style;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)setButtonStyle:(MYSFormButtonStyle)buttonStyle
{
    _buttonStyle = buttonStyle;
    if (self.buttonStyle == MYSFormButtonStyleDefault) {
        self.layer.cornerRadius = 0;
        self.layer.borderWidth  = 0;
    }
    else if (self.buttonStyle == MYSFormButtonStyleBordered) {
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth  = 1.0;
    }
    else if (self.buttonStyle == MYSFormButtonStyleFilled) {
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth  = 1.0;
    }
    [self setNeedsLayout];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.buttonStyle == MYSFormButtonStyleDefault) {
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        self.layer.borderColor = nil;
        self.backgroundColor = nil;
    }
    else if (self.buttonStyle == MYSFormButtonStyleBordered) {
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        self.layer.borderColor = self.tintColor.CGColor;
        self.backgroundColor = nil;
    }
    else if (self.buttonStyle == MYSFormButtonStyleFilled) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:self.tintColor forState:UIControlStateHighlighted];
        self.layer.borderColor = self.tintColor.CGColor;
        self.backgroundColor = self.tintColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.buttonStyle == MYSFormButtonStyleDefault) {
        self.titleLabel.textColor = self.tintColor;
    }
    else if (self.buttonStyle == MYSFormButtonStyleBordered) {
        self.titleLabel.textColor = self.tintColor;
    }
    else if (self.buttonStyle == MYSFormButtonStyleFilled) {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

@end
