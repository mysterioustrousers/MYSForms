//
//  MYSFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "private.h"
#import "MYSForms.h"
#import "MYSFormMessageElement.h"
#import "MYSFormLoadingCell.h"


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
@end


@implementation MYSFormViewController

- (void)commonInit
{
    self.elements = [NSMutableArray new];
    [self configureForm];
}

- (instancetype)init
{
    self = [super initWithCollectionViewLayout:[MYSFormCollectionViewSpringyLayout new]];
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

    self.collectionView.backgroundColor         = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor                   = [UIColor groupTableViewBackgroundColor];
    self.collectionView.alwaysBounceVertical    = YES;

    [self registerElementCellsForReuse];
    [self setupKeyboardNotifications];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top += self.collectionView.bounds.size.height;
    self.collectionView.contentInset = insets;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top -= self.collectionView.bounds.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.contentInset = insets;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[self visibleTextInputs] firstObject] becomeFirstResponder];
        });
    }];
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
        if (element.modelKeyPath && ![element.modelKeyPath isEqualToString:@""]) {
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

    [MYSFormMessageCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormLoadingCell registerForReuseWithCollectionView:self.collectionView];
}

- (void)addFormElement:(MYSFormElement *)element
{
    [self addFormElement:element atIndex:[self.elements count]];
}

- (void)addFormElement:(MYSFormElement *)element atIndex:(NSInteger)index
{
    element.dataSource  = self;
    element.delegate    = self;
    [self.elements insertObject:element atIndex:index];
    if (self.model && element.modelKeyPath && ![element.modelKeyPath isEqualToString:@""]) {
        [self addObserver:self.model
               forKeyPath:element.modelKeyPath
                  options:0
                  context:NULL];
    }
    [element updateCell];
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
    return [self.elements count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYSFormElement *element = self.elements[indexPath.row];

    MYSFormCell *cell = element.cell;
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([element cellClass]) forIndexPath:indexPath];
        [cell populateWithElement:element];
        element.cell = cell;
        [element updateCell];
    }

    return cell;
}




#pragma mark - DELEGATE flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
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




#pragma mark - DATASOURCE form element

- (id)modelValueForFormElement:(MYSFormElement *)formElement
{
    return [self.model valueForKeyPath:formElement.modelKeyPath];
}




#pragma mark - DELEGATE form element

- (void)formElement:(MYSFormElement *)formElement valueDidChange:(id)value
{
    [self.model setValue:value forKeyPath:formElement.modelKeyPath];
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
            NSIndexPath *ip = [self.collectionView indexPathForCell:childElement.cell];
            if (ip) {
                [self.elements removeObject:childElement];
                [indexPathsToRemove addObject:ip];
            }
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
                [self.formDelegate formViewControllerDidSubmit:self];
            }
        }
    }];
}


#pragma mark (KVO helpers)

- (void)removeAllModelObservers
{
    if (self.model) {
        for (MYSFormElement *element in self.elements) {
            if (element.modelKeyPath && ![element.modelKeyPath isEqualToString:@""]) {
                @try {
                    [self.model removeObserver:self forKeyPath:element.modelKeyPath];
                }
                @catch (NSException *exception) {}
            }
        }
    }
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

@end
