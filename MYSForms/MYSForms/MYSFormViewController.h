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
#import "MYSFormLabelAndButtonElement.h"


@protocol MYSFormViewControllerDelegate;



/**
 This view controller can be used to manage a collection view, using it to display a form with a wealth of features. You simply
 create one of these form view controllers and configure it by adding form elements to it. You can also subclass it, making it
 compatible with storyboards. Drag a Collection View Controller onto your storyboard and assign your subclass to it. When it is 
 instantiated, your implementation of `configureForm` will be called where you can add form elements.
 */
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
 If you create your own custom form elements, this is where you need to register their cell xibs with the collection view.
 You must call super as part of your implementation.
 */
- (void)registerElementCellsForReuse;

/**
 Create subclasses of `MYSFormElement` and use this method to add them to the form. Elements will be displayed in the order they were
 added with this method.
 */
- (void)addFormElement:(MYSFormElement *)element;

/**
 Allows you to add an element at a specific index;
 */
- (void)addFormElement:(MYSFormElement *)element atIndex:(NSInteger)index;

/**
 Runs all the validations on the model and adds validation errors by the elements that failed their validations.
 Returns YES if there were no errors and NO if there were validation errors.
 */
- (BOOL)validate;

/**
 Provided an element has a non-nil value for `loadingMessage`, a loading form element will be displayed below each element passed in.
 If `nil` is passed in as `elements`, all elements with a loading message will display a loading element below them.
 */
- (void)showLoadingForElements:(NSArray *)elements;

/**
 If any element passed into this method is currently displaying loading element below it, it will be hid.
 If `nil` is passed in as `elements`, all elements currently display a loading element will have the loading element hid.
 */
- (void)hideLoadingForElements:(NSArray *)elements;

@end




/**
 Allows you to be informed of interesting events that happen with the form.
 */
@protocol MYSFormViewControllerDelegate <NSObject>

/**
 On every text input before the last, the return key on the iOS keyboard will be "Next", moving them to the next text input field.
 On the last text input field, the return key will be a "Done" button and when pressed, this delegate method will be called, indicating
 the user is done filling out the form. You can call `validate` in this method to make sure all forms are filled out correctly and if
 `validate` returns YES, proceed with processing the model the form populated.
 */
- (void)formViewControllerDidSubmit:(MYSFormViewController *)controller;

@end
