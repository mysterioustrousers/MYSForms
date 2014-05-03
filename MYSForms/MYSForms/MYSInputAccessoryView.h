//
//  MYSInputAccessoryView.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


@protocol MYSInputAccessoryViewDelegate;


@interface MYSInputAccessoryView : UIToolbar
@property (nonatomic, weak)          id<MYSInputAccessoryViewDelegate> accessoryViewDelegate;
@property (nonatomic, weak) IBOutlet UIBarButtonItem                   *previousButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem                   *nextButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem                   *dismissButton;
+ (instancetype)accessoryViewWithDelegate:(id<MYSInputAccessoryViewDelegate>)delegate;
@end


@protocol MYSInputAccessoryViewDelegate <NSObject>
- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressPreviousButton:(UIBarButtonItem *)button;
- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressNextButton:(UIBarButtonItem *)button;
- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressDismissButton:(UIBarButtonItem *)button;
@end