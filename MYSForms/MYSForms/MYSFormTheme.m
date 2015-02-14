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

#define MERGE(a, b, s) if ((s == MYSFormThemeMergeStrategyPassive    && !a) || \
                           (s == MYSFormThemeMergeStrategyAggressive && b)) \
                                a = [b copy]

- (void)mergeWithTheme:(MYSFormTheme *)theme strategy:(MYSFormThemeMergeStrategy)strategy
{
    MERGE(_labelFont,            theme.labelFont,            strategy);
    MERGE(_labelTextColor,       theme.labelTextColor,       strategy);
    MERGE(_contentInsets,        theme.contentInsets,        strategy);
    MERGE(_padding,              theme.padding,              strategy);
    MERGE(_backgroundColor,      theme.backgroundColor,      strategy);
    MERGE(_height,               theme.height,               strategy);
    MERGE(_inputLabelFont,       theme.inputLabelFont,       strategy);
    MERGE(_inputLabelColor,      theme.inputLabelColor,      strategy);
    MERGE(_inputTextFont,        theme.inputTextFont,        strategy);
    MERGE(_inputTextColor,       theme.inputTextColor,       strategy);
    MERGE(_tintColor,            theme.tintColor,            strategy);
    MERGE(_messageTextFont,      theme.messageTextFont,      strategy);
    MERGE(_messageTextColor,     theme.messageTextColor,     strategy);
    MERGE(_buttonStyle,          theme.buttonStyle,          strategy);
    MERGE(_buttonTitleFont,      theme.buttonTitleFont,      strategy);
    MERGE(_toggleOnTintColor,    theme.toggleOnTintColor,    strategy);
    MERGE(_toggleThumbTintColor, theme.toggleThumbTintColor, strategy);
}

@end
