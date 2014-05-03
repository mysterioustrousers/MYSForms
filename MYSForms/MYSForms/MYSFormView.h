//
//  MYSFormViewController.h
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


@class MYSFormHeadlineCellData;
@class MYSFormFootnoteCellData;
@class MYSFormTextInputCellData;
@class MYSFormButtonCellData;




@interface MYSFormView : UICollectionView

/**
 Set the model for this form. As you add form elements, you will associated those elements with key paths on the model and they will
 be linked bi-directionally. The form element will always display the current value of the model and the model will always be
 updated as the form element is updated by the user.
 */
@property (nonatomic, strong) id model;

/**
 If your method of choice is to subclass `MYSFormCollectionView`, override this method in your subclass to configure your form.
 */
- (void)configureForm;

/**
 Add a headline form element. This is a display element and not an input element, so it cannot be linked to a property on the model.
 */
- (MYSFormHeadlineCellData *)addHeadlineElementWithString:(NSString *)headline;

/**
 Add a footnote form element. This is a display element and not an input element, so it cannot be linked to a property on the model.
 */
- (MYSFormFootnoteCellData *)addFootnoteElementWithString:(NSString *)footnote;

/**
 Add a text input form element. Provide a keypath to a property on `model` and that property will be bound to the value of the input.
 */
- (MYSFormTextInputCellData *)addTextInputElementWithModelKeyPath:(NSString *)keyPath
                                                            label:(NSString *)label
                                                     keyboardType:(UIKeyboardType)keyboardType
                                                           secure:(BOOL)secure;


/**
 Add a button form element. this is useful for submit buttons for example. This does not edit anything so it is not bound to a 
 model keyPath.
 */
- (MYSFormButtonCellData *)addButtonElementWithTitle:(NSString *)title target:(id)target action:(SEL)action;


@end

