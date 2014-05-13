//
//  MYSFormElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormPresenceValidation.h"
#import "MYSFormRegexValidation.h"


@class MYSFormElement;
@class MYSFormCell;


@protocol MYSFormElementDataSource;
@protocol MYSFormElementDelegate;


/**
 Do not create direct instances of this class. It is meant to be subclassed.
 */
@interface MYSFormElement : NSObject

/**
 When creating custom form elements, you this will be set up for you and you can use the delegate methods to instruct
 the form view controller to do a variety of things for you.
 */
@property (nonatomic, weak) id<MYSFormElementDelegate> delegate;

/**
 When creating custom form elements, you can use this to get information about the form's model.
 */
@property (nonatomic, weak) id<MYSFormElementDataSource> dataSource;


/**
 The key path to the property on the forms model that this element should be bound to.
 */
@property (nonatomic, copy) NSString *modelKeyPath;

/**
 The cell ued to display this form element. This is `nil` until the collection view that displays the form creates it.
 */
@property (nonatomic, strong) MYSFormCell *cell;

/**
 The class of the cell to be used to display this form element.
 */
- (Class)cellClass;

/**
 If any data on this element has changed, call this method to update the cell so it's displayed to the user.
 */
- (void)updateCell;

/**
 Returns YES if this is the type of form element that accepts text input.
 */
- (BOOL)isTextInput;

/**
 Returns YES if the `modelKeyPath` is valid for use setting and getting values on the model. An attempt to do so with an invalid
 `modelKeyPath` will result in an exception, so always use this to check first.
 */
- (BOOL)isModelKeyPathValid;

/**
 Add a validation for this element so that when `validationErrors` is called, the validation will be run against the value of
 the form element and generate an error if a validation fails.
 */
- (void)addFormValidation:(MYSFormValidation *)formValidation;

/**
 Will return either an empty array or an arry of NSError objects that contain `localizedDescription`s of the failure reason.
 */
- (NSArray *)validationErrors;

/**
 Add a value transformer that takes the value at `modelKeyPath` and transforms it to what the element cell expects. You can also
 provide a reverse transform that will transform the cell value back to type of value the model expects.
 */
@property (nonatomic, retain) NSValueTransformer *valueTransformer;

/**
 This will enable/disable all input views in the cell of the form element.
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end


@protocol MYSFormElementDataSource <NSObject>
- (id)modelValueForFormElement:(MYSFormElement *)formElement;
@end


@protocol MYSFormElementDelegate <NSObject>
- (void)formElement:(MYSFormElement *)formElement valueDidChange:(id)value;
- (void)formElement:(MYSFormElement *)formElement didRequestPresentationOfActionSheet:(UIActionSheet *)actionSheet;
- (void)formElement:(MYSFormElement *)formElement didRequestPresentationOfViewController:(UIViewController *)viewController
           animated:(BOOL)animated
         completion:(void (^)(void))completion;
@end


