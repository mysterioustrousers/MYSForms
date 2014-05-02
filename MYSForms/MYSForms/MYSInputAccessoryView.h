//
//  MYSInputAccessoryView.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


@protocol MYSInputAccessoryViewDelegate;


@interface MYSInputAccessoryView : UIView
@property (nonatomic, weak)          id<MYSInputAccessoryViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton                          *previousButton;
@property (nonatomic, weak) IBOutlet UIButton                          *nextButton;
@property (nonatomic, weak) IBOutlet UIButton                          *dismissButton;
+ (instancetype)accessoryViewWithDelegate:(id<MYSInputAccessoryViewDelegate>)delegate;
@end


@protocol MYSInputAccessoryViewDelegate <NSObject>
- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressPreviousButton:(UIButton *)button;
- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressNextButton:(UIButton *)button;
- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressDismissButton:(UIButton *)button;
@end