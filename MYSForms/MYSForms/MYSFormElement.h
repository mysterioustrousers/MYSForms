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


/**
 Do not create direct instances of this class. It is meant to be subclassed.
 */
@interface MYSFormElement : NSObject

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
 Add a validation for this element so that when `validationErrors` is called, the validation will be run against the value of
 the form element and generate an error if a validation fails.
 */
- (void)addFormValidation:(MYSFormValidation *)formValidation;

/**
 Will return either an empty array or an arry of NSError objects that contain `localizedDescription`s of the failure reason.
 */
- (NSArray *)validationErrors;

/**
 This will enable/disable all input views in the cell of the form element.
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
