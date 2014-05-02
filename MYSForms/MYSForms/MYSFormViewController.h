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


@protocol MYSFormViewControllerDelegate;




@interface MYSFormViewController : UICollectionViewController

/**
 Receives messages regarding actions the user takes while interacting with your form.
 */
@property (nonatomic, weak) id<MYSFormViewControllerDelegate> delegate;

/**
 Set the model for this form. As you add form elements, you will associated those elements with key paths on the model and they will
 be linked bi-directionally.
 */
@property (nonatomic, weak, readonly) id model;

/**
 Use this method to create a form view controller, then use the methods below to add form elements. This is the only valid 
 way to create a form view controller.
 */
+ (instancetype)newFormViewControllerWithModel:(id)model;

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
                                                      placeholder:(NSString *)placeholder;

/**
 Add a button form element. this is useful for submit buttons for example. This does not edit anything so it is not bound to a 
 model keyPath.
 */
- (MYSFormButtonCellData *)addButtonElementWithTitle:(NSString *)title target:(id)target action:(SEL)action;


@end




@protocol MYSFormViewControllerDelegate <NSObject>
@end
