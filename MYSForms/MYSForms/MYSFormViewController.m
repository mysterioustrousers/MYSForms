//
//  MYSFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSForms.h"
#import "MYSFormMessageElement.h"
#import "MYSFormLoadingCell.h"
#import "MYSFormMessageElement-Private.h"
#import "MYSCollectionViewSpringyLayout.h"
#import "MYSCollectionView.h"


typedef NS_ENUM(NSUInteger, MYSFormMessagePosition) {
    MYSFormMessagePositionAbove,
    MYSFormMessagePositionBelow
};


@interface MYSFormViewController () <UICollectionViewDelegateFlowLayout,
                                     UITextFieldDelegate,
                                     MYSFormElementDataSource,
                                     MYSFormElementDelegate>
@property (nonatomic, strong) NSMutableArray      *elements;
@property (nonatomic, strong) NSMutableDictionary *cachedCellSizes;
@property (nonatomic, assign) NSUInteger          outstandingValidationErrorCount;
@property (nonatomic, assign) BOOL                appearedFirstTime;

// picker view presentation
@property (nonatomic, strong) NSLayoutConstraint  *pickerViewYConstraint;
@property (nonatomic, strong) UIPickerView        *pickerView;
@property (nonatomic, strong) UIButton            *pickerViewButton;

@end


@implementation MYSFormViewController

- (void)commonInit
{
    self.elements = [NSMutableArray new];
    self.appearedFirstTime = NO;
    [self configureForm];
}

- (instancetype)init
{
    self = [super initWithCollectionViewLayout:[MYSCollectionViewSpringyLayout new]];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.backgroundColor      = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor                = [UIColor groupTableViewBackgroundColor];
    self.collectionView.alwaysBounceVertical = YES;

    [self registerElementCellsForReuse];
    [self setupKeyboardNotifications];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.appearedFirstTime) {
        UIEdgeInsets insets = self.collectionView.contentInset;
        insets.top += self.collectionView.bounds.size.height;
        self.collectionView.contentInset = insets;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.appearedFirstTime) {
        self.appearedFirstTime = YES;
        UIEdgeInsets insets = self.collectionView.contentInset;
        insets.top -= self.collectionView.bounds.size.height;
        [UIView animateWithDuration:0.5 animations:^{
            self.collectionView.contentInset = insets;
        } completion:^(BOOL finished) {
            if (self.isEditing) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[[self visibleTextInputs] firstObject] becomeFirstResponder];
                });
            }
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllModelObservers];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.cachedCellSizes removeAllObjects];
}




#pragma mark - Public

- (void)setModel:(id)model
{
    [self removeAllModelObservers];
    _model = model;
    for (MYSFormElement *element in self.elements) {
        if ([self elementHasValidKeyPath:element]) {
            [self.model addObserver:self
                         forKeyPath:element.modelKeyPath
                            options:0
                            context:NULL];
        }
        [element updateCell];
    }
}

- (void)configureForm
{
    // overriden by subclasses
}

- (void)registerElementCellsForReuse
{
    [MYSFormHeadlineCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormFootnoteCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormTextFieldCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormButtonCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormLabelAndButtonCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormImagePickerCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormPickerCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormToggleCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormTextViewCell registerForReuseWithCollectionView:self.collectionView];

    [MYSFormMessageCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormLoadingCell registerForReuseWithCollectionView:self.collectionView];

    // register an invisble footer cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"InvisibleCell"];
}

- (void)addFormElement:(MYSFormElement *)element
{
    [self addFormElement:element atIndex:[self.elements count]];
}

- (void)addFormElement:(MYSFormElement *)element atIndex:(NSInteger)index
{
    if ([element isKindOfClass:[MYSFormImagePickerElement class]] &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return;
    }

    element.dataSource  = self;
    element.delegate    = self;
    [self.elements insertObject:element atIndex:index];
    if ([self elementHasValidKeyPath:element]) {
        [self addObserver:self.model
               forKeyPath:element.modelKeyPath
                  options:0
                  context:NULL];
    }
}

- (BOOL)validate
{
    if (!self.collectionView.window) return YES;

    // validate and add any needed form error elements
    BOOL valid = YES;
    NSMutableArray *errorElementsToShow = [NSMutableArray new];
    for (MYSFormElement *element in self.elements) {
        NSArray *validationErrors = [element validationErrors];
        if ([validationErrors count] > 0) {
            valid = NO;
            for (NSError *error in validationErrors) {
                MYSFormMessageElement *errorFormElement = [MYSFormMessageElement messageElementWithMessage:[error localizedDescription]
                                                                                                      type:MYSFormMessageTypeValidationError
                                                                                             parentElement:element];
                [errorElementsToShow addObject:errorFormElement];
            }
        }
    }
    self.outstandingValidationErrorCount = [errorElementsToShow count];

    // remove all existing error elements
    [self hideChildrenOfElement:nil type:MYSFormMessageTypeValidationError completion:^{
        [self showChildElements:errorElementsToShow position:MYSFormMessagePositionBelow duration:0 completion:nil];
    }];

    return valid;
}

- (void)showLoadingMessage:(NSString *)message aboveElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;
    MYSFormMessageElement *loadingElement = [MYSFormMessageElement messageElementWithMessage:message type:MYSFormMessageTypeLoading parentElement:element];
    [self showChildElements:@[loadingElement] position:MYSFormMessagePositionAbove duration:0 completion:completion];
}

- (void)hideLoadingAboveElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;
    [self hideChildrenOfElement:element type:MYSFormMessageTypeLoading completion:completion];
}

- (void)showErrorMessage:(NSString *)message
            belowElement:(MYSFormElement *)element
                duration:(NSTimeInterval)duration
              completion:(void (^)(void))completion
{
    MYSFormMessageElement *errorMessage = [MYSFormMessageElement messageElementWithMessage:message
                                                                                      type:MYSFormMessageTypeError
                                                                             parentElement:element];
    [self showChildElements:@[errorMessage]
                   position:MYSFormMessagePositionBelow
                   duration:duration
                 completion:completion];
}

- (void)hideErrorMessageBelowElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    [self hideChildrenOfElement:element type:MYSFormMessageTypeError completion:completion];
}

- (void)showSuccessMessage:(NSString *)message
              belowElement:(MYSFormElement *)element
                  duration:(NSTimeInterval)duration
                completion:(void (^)(void))completion
{
    MYSFormMessageElement *successMessage = [MYSFormMessageElement messageElementWithMessage:message
                                                                                        type:MYSFormMessageTypeSuccess
                                                                               parentElement:element];
    [self showChildElements:@[successMessage]
                   position:MYSFormMessagePositionBelow
                   duration:duration
                 completion:completion];
}

- (void)hideSuccessMessageBelowElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    [self hideChildrenOfElement:element type:MYSFormMessageTypeSuccess completion:completion];
}




#pragma mark - DATASOURCE collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.elements count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < [self.elements count]) {
        MYSFormElement *element = self.elements[indexPath.row];
        MYSFormCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([element cellClass]) forIndexPath:indexPath];
        [cell populateWithElement:element];
        element.cell = cell;
        [element updateCell];
        return cell;
    }

    // have to do this because there's some bug I can't figure out that causes the last cell in a collection view to jump/stutter
    // when rows are inserted.
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InvisibleCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}




#pragma mark - DELEGATE flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < [self.elements count]) {
        NSValue *cachedSize = self.cachedCellSizes[indexPath];
        if (!cachedSize) {
            MYSFormElement *element = self.elements[indexPath.row];
            CGSize size = [[element cellClass] sizeRequiredForElement:element width:collectionView.frame.size.width];
            size.width = collectionView.frame.size.width;
            cachedSize = [NSValue valueWithCGSize:size];
            self.cachedCellSizes[indexPath] = cachedSize;
        }
        return [cachedSize CGSizeValue];
    }
    return CGSizeMake(self.collectionView.frame.size.width, 50);
}




#pragma mark - DATASOURCE form element

- (id)modelValueForFormElement:(MYSFormElement *)formElement
{
    if ([self elementHasValidKeyPath:formElement]) {
        id value = [self.model valueForKeyPath:formElement.modelKeyPath];

        // transform the value if needed
        if (formElement.valueTransformer && [[formElement.valueTransformer class] allowsReverseTransformation]) {
            value = [formElement.valueTransformer transformedValue:value];
        }

        return value;
    }
    return nil;
}




#pragma mark - DELEGATE form element

- (void)formElement:(MYSFormElement *)formElement valueDidChange:(id)value
{
    // transform the value if needed
    if (formElement.valueTransformer && [[formElement.valueTransformer class] allowsReverseTransformation]) {
        value = [formElement.valueTransformer reverseTransformedValue:value];
    }

    if ([self elementHasValidKeyPath:formElement]) {
        [self.model setValue:value forKeyPath:formElement.modelKeyPath];
        if ([self.formDelegate respondsToSelector:@selector(formViewController:didUpdateModelWithValue:element:)]) {
            [self.formDelegate formViewController:self didUpdateModelWithValue:value element:formElement];
        }
    }
    else {
        if ([self.formDelegate respondsToSelector:@selector(formViewController:failedToUpdateModelWithValue:element:)]) {
            [self.formDelegate formViewController:self failedToUpdateModelWithValue:value element:formElement];
        }
    }
}

- (void)formElement:(MYSFormElement *)formElement didRequestPresentationOfActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet showInView:self.view];
}

- (void)formElement:(MYSFormElement *)formElement didRequestPresentationOfViewController:(UIViewController *)viewController
           animated:(BOOL)animated
         completion:(void (^)(void))completion
{
    [self presentViewController:viewController animated:animated completion:completion];
}

- (void)formElement:(MYSFormElement *)formElement didRequestPresentationOfPickerView:(UIPickerView *)pickerView
{
    [self displayPickerView:pickerView];
}





#pragma mark - KVO (the model changed)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    for (MYSFormElement *element in self.elements) {
        if ([element.modelKeyPath isEqualToString:keyPath]) {
            if (![[element.cell textInput] isFirstResponder]) {
                [element updateCell];
            }
            return;
        }
    }
}




#pragma mark - Private

#pragma mark (showing/hiding child elements)

- (void)showChildElements:(NSArray *)childElements position:(MYSFormMessagePosition)position duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;

    for (MYSFormMessageElement *childElement in childElements) {
        if (!childElement.parentElement) {
            childElement.parentElement = (MYSFormElement *)[self.elements firstObject];
        }
    }

    NSMutableArray *indexPathsToInsert  = [NSMutableArray new];

    for (MYSFormElement *element in [self.elements copy]) {
        NSInteger indexOffset       = position == MYSFormMessagePositionBelow ? 1 : 0;
        NSInteger indexMultiplier   = position == MYSFormMessagePositionBelow ? 1 : -1;
        for (MYSFormMessageElement *childElement in childElements) {
            if ([element isEqual:childElement.parentElement]) {
                NSInteger index = [self.elements indexOfObject:childElement.parentElement];
                NSAssert(index != NSNotFound, @"element must be added to the form.");

                NSInteger newIndex = index + (indexOffset++ * indexMultiplier);
                [self addFormElement:childElement atIndex:newIndex];
                [indexPathsToInsert addObject:[NSIndexPath indexPathForItem:newIndex inSection:0]];

                if (duration > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self hideChildrenOfElement:childElement.parentElement type:childElement.type completion:nil];
                    });
                }
            }
        }
    }

    if ([indexPathsToInsert count] > 0) {
        [self.cachedCellSizes removeAllObjects];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
    else {
        if (completion) completion();
    }

}

- (void)hideChildrenOfElement:(MYSFormElement *)parentElement type:(MYSFormMessageType)type completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;

    NSArray *childElements = [self.elements filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MYSFormElement *element, NSDictionary *bindings) {
        return ([element isKindOfClass:[MYSFormMessageElement class]] &&
                [(MYSFormMessageElement *)element type] == type);
    }]];

    NSMutableArray *indexPathsToRemove = [NSMutableArray new];
    for (MYSFormMessageElement *childElement in childElements) {
        if (!parentElement || [childElement.parentElement isEqual:parentElement]) {
            NSInteger index = [self.elements indexOfObject:childElement];
            NSIndexPath *ip = [NSIndexPath indexPathForItem:index inSection:0];
            [self.elements removeObject:childElement];
            [indexPathsToRemove addObject:ip];
        }
    }

    if ([indexPathsToRemove count] > 0) {
        [self.cachedCellSizes removeAllObjects];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:indexPathsToRemove];
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
    else {
        if (completion) completion();
    }
}




#pragma mark (keyboard)

- (void)setupKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        CGRect endFrame             = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat animationDuration   = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve  = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIEdgeInsets insets         = self.collectionView.contentInset;
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
            self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            insets.bottom = endFrame.size.height;
        }
        else {
            insets.bottom = endFrame.size.width;
        }
        [UIView animateWithDuration:animationDuration delay:0 options:(curve << 16) animations:^{
            self.collectionView.contentInset = insets;
        } completion:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        CGFloat animationDuration   = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve  = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIEdgeInsets insets         = self.collectionView.contentInset;
        insets.bottom               = 0;
        [UIView animateWithDuration:animationDuration delay:0 options:(curve << 16) animations:^{
            self.collectionView.contentInset = insets;
        } completion:nil];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        UITextField *textField = note.object;
        if ([[self visibleTextInputs] containsObject:textField]) {
            if ([self textInputAfter:textField]) {
                textField.returnKeyType = UIReturnKeyNext;
            }
            else {
                textField.returnKeyType = UIReturnKeyDone;
            }
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        UITextField *textField = note.object;
        if ([[self visibleTextInputs] containsObject:textField]) {
            if (self.outstandingValidationErrorCount > 0) {
                [self validate];
            }
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:MYSFormTextFieldCellDidHitReturnKey
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        UITextField *textField = note.object;
        if ([[self visibleTextInputs] containsObject:textField]) {
            UIView *nextTextInput = [self textInputAfter:textField];
            if (nextTextInput) {
                [nextTextInput becomeFirstResponder];
            }
            else {
                if ([self.formDelegate respondsToSelector:@selector(formViewControllerDidSubmit:)]) {
                    [self.formDelegate formViewControllerDidSubmit:self];
                }
            }
        }
    }];
}


#pragma mark (KVO helpers)

- (void)removeAllModelObservers
{
    if (self.model) {
        for (MYSFormElement *element in self.elements) {
            if ([self elementHasValidKeyPath:element]) {
                @try {
                    [self.model removeObserver:self forKeyPath:element.modelKeyPath];
                }
                @catch (NSException *exception) {}
            }
        }
    }
}

- (BOOL)elementHasValidKeyPath:(MYSFormElement *)element
{
    BOOL hasModel   = self.model != nil;
    BOOL isValid    = [element isModelKeyPathValid];
    return hasModel && isValid;
}


#pragma mark (text input)

- (UIView *)textInputAfter:(UIView *)textInput
{
    BOOL textInputFound = NO;
    for (MYSFormElement *element in self.elements) {
        if ([element.cell textInput] == textInput) {
            textInputFound = YES;
            continue;
        }
        if (textInputFound && [element.cell textInput].window) {
            return [element.cell textInput];
        }
    }
    return nil;
}

- (NSArray *)visibleTextInputs
{
    NSMutableArray *visibleTextInputs = [NSMutableArray new];
    for (MYSFormElement *element in self.elements) {
        UIView * textInput = [element.cell textInput];
        if (textInput.window) {
            [visibleTextInputs addObject:textInput];
        }
    }
    return visibleTextInputs;
}

// TODO: if the next text input is off screen, we need to scroll to it first, then give it first responder status.
- (NSArray *)textInputElements
{
    NSMutableArray *textInputs = [NSMutableArray new];
    for (MYSFormElement *element in self.elements) {
        if ([element isTextInput]) {
            [textInputs addObject:element];
        }
    }
    return textInputs;
}

- (UIView *)currentFirstResponder
{
    NSArray *visibleTextInputs = [self visibleTextInputs];
    for (UIView *textInput in visibleTextInputs) {
        if ([textInput isFirstResponder]) {
            return textInput;
        }
    }
    return nil;
}


#pragma mark (ui)

- (void)displayPickerView:(UIPickerView *)pickerView
{
    self.pickerView = pickerView;

    UIView *wrapperView = [self.view superview];

    // set up constraints for picker view
    [pickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [wrapperView addSubview:pickerView];

    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:wrapperView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:pickerView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0]];

    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:wrapperView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:pickerView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0]];

    NSLayoutConstraint *yConstraint =
    [NSLayoutConstraint constraintWithItem:wrapperView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:pickerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:-(pickerView.frame.size.height + 44)];
    [wrapperView addConstraint:yConstraint];


    // create and set up constrains for done label
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [doneButton setBackgroundColor:[UIColor whiteColor]];
    [doneButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [doneButton addTarget:self
                   action:@selector(pickerViewDoneButtonWasTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    [wrapperView addSubview:doneButton];

    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:doneButton
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:pickerView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0]];

    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:doneButton
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:pickerView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0]];

    [wrapperView addConstraint:[NSLayoutConstraint constraintWithItem:doneButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:pickerView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];

    [doneButton addConstraint:[NSLayoutConstraint constraintWithItem:doneButton
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:44]];

    [wrapperView layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        yConstraint.constant = 0;
        [wrapperView layoutIfNeeded];
    }];

    self.pickerView             = pickerView;
    self.pickerViewButton       = doneButton;
    self.pickerViewYConstraint  = yConstraint;
}

- (IBAction)pickerViewDoneButtonWasTapped:(id)sender
{
    UIView *wrapperView = [self.view superview];
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerViewYConstraint.constant = -(self.pickerView.frame.size.height + 44);
        [wrapperView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        [self.pickerViewButton removeFromSuperview];
    }];
}

@end
