//
//  MYSFormButton.h
//  MYSForms
//
//  Created by Adam Kirk on 1/10/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MYSFormElement;


typedef void(^MYSFormButtonActionBlock)(MYSFormElement *element);


typedef NS_ENUM(NSInteger, MYSFormButtonStyle) {
    // allows the style to be overridden by a form theme.
    MYSFormButtonStyleNone,
    MYSFormButtonStyleDefault,
    MYSFormButtonStyleBordered,
    MYSFormButtonStyleFilled
};


@interface MYSFormButton : UIButton

@property (nonatomic, copy) MYSFormButtonActionBlock action;

@property (nonatomic) MYSFormButtonStyle buttonStyle;

+ (instancetype)formButtonWithTitle:(NSString *)title style:(MYSFormButtonStyle)style action:(MYSFormButtonActionBlock)action;

@end
