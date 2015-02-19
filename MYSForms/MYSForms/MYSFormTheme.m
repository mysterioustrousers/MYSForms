//
//  MYSFormTheme.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTheme.h"


@implementation MYSFormTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        _labelFont             = nil;
        _labelTextColor        = nil;
        _padding               = nil;
        _backgroundColor       = nil;
        _height                = nil;
        _inputLabelFont        = nil;
        _inputLabelColor       = nil;
        _inputTextFont         = nil;
        _inputTextColor        = nil;
        _tintColor             = nil;
        _messageTextFont       = nil;
        _messageTextColor      = nil;
        _buttonStyle           = nil;
        _buttonTitleFont       = nil;
        _toggleOnTintColor     = nil;
        _toggleThumbTintColor  = nil;
    }
    return self;
}

+ (instancetype)formThemeWithLabelFont:(UIFont *)font
{
    MYSFormTheme *theme = [self new];
    theme.labelFont = font;
    return theme;
}

+ (instancetype)formThemeWithLabelFont:(UIFont *)font height:(CGFloat)height contentInsets:(UIEdgeInsets)insets
{
    MYSFormTheme *theme = [self formThemeWithLabelFont:font];
    theme.height        = @(height);
    theme.contentInsets = [NSValue valueWithUIEdgeInsets:insets];
    return theme;
}

+ (instancetype)formThemeWithDefaults
{
    MYSFormTheme *theme = [self new];
    theme.labelFont              = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    theme.labelTextColor         = [UIColor blackColor];
    theme.contentInsets          = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    theme.padding                = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    theme.backgroundColor        = [UIColor whiteColor];
    theme.height                 = nil;
    theme.inputLabelFont         = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    theme.inputLabelColor        = [UIColor lightGrayColor];
    theme.inputTextFont          = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    theme.inputTextColor         = [UIColor blackColor];
    theme.tintColor              = nil;
    theme.messageTextFont        = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    theme.messageTextColor       = [UIColor blackColor];
    theme.buttonStyle            = @(MYSFormButtonStyleDefault);
    theme.buttonTitleFont        = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    theme.toggleOnTintColor      = nil;
    theme.toggleThumbTintColor   = nil;
    return theme;
}

#define MERGE(a, b) if (b) { a = [b copy]; }

- (void)mergeWithTheme:(MYSFormTheme *)theme
{
    MERGE(_labelFont,            theme.labelFont);
    MERGE(_labelTextColor,       theme.labelTextColor);
    MERGE(_contentInsets,        theme.contentInsets);
    MERGE(_padding,              theme.padding);
    MERGE(_backgroundColor,      theme.backgroundColor);
    MERGE(_height,               theme.height);
    MERGE(_inputLabelFont,       theme.inputLabelFont);
    MERGE(_inputLabelColor,      theme.inputLabelColor);
    MERGE(_inputTextFont,        theme.inputTextFont);
    MERGE(_inputTextColor,       theme.inputTextColor);
    MERGE(_tintColor,            theme.tintColor);
    MERGE(_messageTextFont,      theme.messageTextFont);
    MERGE(_messageTextColor,     theme.messageTextColor);
    MERGE(_buttonStyle,          theme.buttonStyle);
    MERGE(_buttonTitleFont,      theme.buttonTitleFont);
    MERGE(_toggleOnTintColor,    theme.toggleOnTintColor);
    MERGE(_toggleThumbTintColor, theme.toggleThumbTintColor);
}

@end
