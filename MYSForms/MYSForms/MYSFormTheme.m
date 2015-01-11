//
//  MYSFormTheme.m
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTheme.h"


#define MERGE(a, b) if (!a) a = [b copy]


@implementation MYSFormTheme

+ (instancetype)formThemeWithLabelFont:(UIFont *)font
{
    MYSFormTheme *theme = [self new];
    theme.labelFont = font;
    return theme;
}

+ (instancetype)formThemeWithLabelFont:(UIFont *)font height:(CGFloat)height contentInsets:(UIEdgeInsets)insets
{
    MYSFormTheme *theme = [self new];
    theme.labelFont = font;
    theme.height = @(height);
    theme.contentInsets = [NSValue valueWithUIEdgeInsets:insets];
    return theme;
}

- (void)mergeWithTheme:(MYSFormTheme *)theme
{
    MERGE(_labelFont,            theme.labelFont);
    MERGE(_labelTextColor,       theme.labelTextColor);
    MERGE(_contentInsets,        theme.contentInsets);
    MERGE(_backgroundColor,      theme.backgroundColor);
    MERGE(_height,               theme.height);
    MERGE(_inputTextFont,        theme.inputTextFont);
    MERGE(_inputTextColor,       theme.inputTextColor);
    MERGE(_tintColor,            theme.tintColor);
    MERGE(_messageTextFont,      theme.messageTextFont);
    MERGE(_messageTextColor,     theme.messageTextColor);
    MERGE(_buttonStyle,          theme.buttonStyle);
    MERGE(_toggleOnTintColor,    theme.toggleOnTintColor);
    MERGE(_toggleThumbTintColor, theme.toggleThumbTintColor);
}


#define GETTER(t, n, d) - (t *)n { if (_##n) { return _##n; } else { return d; } }

GETTER(UIFont,   labelFont,             [UIFont preferredFontForTextStyle:UIFontTextStyleBody]);
GETTER(UIColor,  labelTextColor,        [UIColor blackColor]);
GETTER(NSValue,  contentInsets,         [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)]);
GETTER(UIColor,  backgroundColor,       [UIColor whiteColor]);
GETTER(NSNumber, height,                nil);
GETTER(UIFont,   inputLabelFont,        [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]);
GETTER(UIColor,  inputLabelColor,       [UIColor lightGrayColor]);
GETTER(UIFont,   inputTextFont,         [UIFont preferredFontForTextStyle:UIFontTextStyleBody]);
GETTER(UIColor,  inputTextColor,        [UIColor blackColor]);
GETTER(UIColor,  tintColor,             nil);
GETTER(UIFont,   messageTextFont,       [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]);
GETTER(UIColor,  messageTextColor,      [UIColor blackColor]);
GETTER(NSNumber, buttonStyle,           @(MYSFormButtonStyleDefault));
GETTER(UIColor,  toggleOnTintColor,     nil);
GETTER(UIColor,  toggleThumbTintColor,  nil);

@end
