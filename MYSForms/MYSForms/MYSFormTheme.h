//
//  MYSFormTheme.h
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSFormButton.h"


@interface MYSFormTheme : NSObject

+ (instancetype)formThemeWithLabelFont:(UIFont *)font;

+ (instancetype)formThemeWithLabelFont:(UIFont *)font height:(CGFloat)height contentInsets:(UIEdgeInsets)insets;

- (void)mergeWithTheme:(MYSFormTheme *)theme;

@property (nonatomic, copy) UIFont *labelFont;

@property (nonatomic, copy) UIColor *labelTextColor;

/**
 NSValue of UIEdgeInsets
 */
@property (nonatomic, copy) NSValue *contentInsets;

@property (nonatomic, copy) UIColor *backgroundColor;

@property (nonatomic, copy) NSNumber *height;

@property (nonatomic, copy) UIFont *inputLabelFont;

@property (nonatomic, copy) UIColor *inputLabelColor;

@property (nonatomic, copy) UIFont *inputTextFont;

@property (nonatomic, copy) UIColor *inputTextColor;

@property (nonatomic, copy) UIColor *tintColor;

@property (nonatomic, copy) UIFont *messageTextFont;

@property (nonatomic, copy) UIColor *messageTextColor;

/**
 NSNumber wrapped MYSFormButtonStyle enum value.
 */
@property (nonatomic, copy) NSNumber *buttonStyle;

@property (nonatomic, copy) UIFont *buttonTitleFont;

@property (nonatomic, copy) UIColor *toggleOnTintColor;

@property (nonatomic, copy) UIColor *toggleThumbTintColor;

@end
