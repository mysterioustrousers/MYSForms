//
//  MYSFormViewController.h
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormHeadlineElement.h"
#import "MYSFormFootnoteElement.h"
#import "MYSFormTextFieldElement.h"
#import "MYSFormButtonElement.h"


@protocol MYSFormViewControllerDelegate;


@interface MYSFormViewController : UICollectionViewController

/**
 Set the model for this form. As you add form elements, you will associated those elements with key paths on the model and they will
 be linked bi-directionally. The form element will always display the current value of the model and the model will always be
 updated as the form element is updated by the user.
 */
@property (nonatomic, strong) id model;


/**
 The delegate for the form controller that lets you know of interesting events.
 */
@property (nonatomic, weak) id<MYSFormViewControllerDelegate> formDelegate;

/**
 If your method of choice is to subclass `MYSFormCollectionView`, override this method in your subclass to configure your form.
 */
- (void)configureForm;

/**
 Create subclasses of `MYSFormElement` and use this method to add them to the form. Elements will be displayed in the order they were
 added with this method.
 */
- (void)addFormElement:(MYSFormElement *)element;

/**
 All fields that have a field below them have a return key type of "Next" and when pressed, the cursor is moved to the next field. By
 default, the return key of the last field is "Done" but you can customize it. When the return key is pressed when the last field is
 first responder, you'll be notified by the delegate method.
 */
@property (nonatomic, assign) UIReturnKeyType lastFieldReturnKeyType;


@end


@protocol MYSFormViewControllerDelegate <NSObject>
- (void)formViewControllerReturnKeyPressedOnLastField:(MYSFormViewController *)controller;
@end