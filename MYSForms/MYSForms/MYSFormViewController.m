//
//  MYSFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSForms.h"
#import "MYSFormElement-Private.h"
#import "MYSFormChildElement-Private.h"
#import "MYSFormMessageChildElement.h"
#import "MYSFormLoadingChildCell.h"
#import "MYSFormViewChildElement.h"
#import "MYSFormViewChildCell.h"


@interface MYSFormViewController () <UICollectionViewDelegateFlowLayout,
                                     UITextFieldDelegate,
                                     MYSFormElementDataSource,
                                     MYSFormElementDelegate>
@property (nonatomic, strong) NSMutableArray      *elements;
@property (nonatomic, strong) NSMutableDictionary *cachedCellSizes;
@property (nonatomic, assign) NSUInteger          outstandingValidationErrorCount;
@property (nonatomic, strong) MYSFormTheme        *theme;
@property (nonatomic        ) BOOL                isAlreadyAppeared;
@end


@implementation MYSFormViewController

- (void)formInit;
{
    self.elements           = [NSMutableArray new];
    self.fixedWidth         = 0;
    self.theme              = [MYSFormTheme new];
    self.isAlreadyAppeared  = NO;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self formInit];
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self formInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self formInit];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isAlreadyAppeared) {
        self.isAlreadyAppeared = YES;
        self.collectionView.alwaysBounceVertical = YES;
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MAX;
        [self configureForm];
        [self registerElementCellsForReuse];
        [self setupKeyboardNotifications];
        if ([self.navigationItem.title length] == 0) {
            self.navigationItem.title = self.title;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllModelObservers];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.cachedCellSizes removeAllObjects];
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.cachedCellSizes removeAllObjects];
    [self.collectionView reloadData];
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

- (void)addFormElement:(MYSFormElement *)element
{
    [self addFormElement:element atIndex:[self.elements count]];
}

- (void)addFormElement:(MYSFormElement *)element atIndex:(NSInteger)index
{
    if (![element canAddElement]) return;

    element.dataSource  = self;
    element.delegate    = self;

    [self.elements insertObject:element atIndex:index];

    if ([self elementHasValidKeyPath:element]) {
        [self.model addObserver:self
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
                MYSFormMessageChildElement *errorFormElement = [MYSFormMessageChildElement messageElementWithMessage:[error localizedDescription]
                                                                                                                type:MYSFormChildElementTypeValidationError
                                                                                                       parentElement:element];
                [errorElementsToShow addObject:errorFormElement];
            }
        }
    }
    self.outstandingValidationErrorCount = [errorElementsToShow count];

    // remove all existing error elements
    [self hideChildrenOfElements:self.elements type:MYSFormChildElementTypeValidationError completion:^{
        [self showChildElements:errorElementsToShow position:MYSFormElementRelativePositionBelow duration:0 completion:nil];
    }];

    return valid;
}

- (void)attemptToDismissKeyboard
{
    [[self currentFirstResponder] resignFirstResponder];
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

- (void)showLoadingMessage:(NSString *)message aboveElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;
    MYSFormMessageChildElement *loadingElement = [MYSFormMessageChildElement messageElementWithMessage:message type:MYSFormChildElementTypeLoading parentElement:element];
    [self showChildElements:@[loadingElement] position:MYSFormElementRelativePositionAbove duration:0 completion:completion];
}

- (void)hideLoadingAboveElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;
    [self hideChildrenOfElements:@[element] type:MYSFormChildElementTypeLoading completion:completion];
}

- (void)showErrorMessage:(NSString *)message
            belowElement:(MYSFormElement *)element
                duration:(NSTimeInterval)duration
              completion:(void (^)(void))completion
{
    MYSFormMessageChildElement *errorMessage = [MYSFormMessageChildElement messageElementWithMessage:message
                                                                                                type:MYSFormChildElementTypeError
                                                                                       parentElement:element];
    [self showChildElements:@[errorMessage]
                   position:MYSFormElementRelativePositionBelow
                   duration:duration
                 completion:completion];
}

- (void)hideErrorMessageBelowElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    [self hideChildrenOfElements:@[element] type:MYSFormChildElementTypeError completion:completion];
}

- (void)showSuccessMessage:(NSString *)message
              belowElement:(MYSFormElement *)element
                  duration:(NSTimeInterval)duration
                completion:(void (^)(void))completion
{
    MYSFormMessageChildElement *successMessage = [MYSFormMessageChildElement messageElementWithMessage:message
                                                                                        type:MYSFormChildElementTypeSuccess
                                                                               parentElement:element];
    [self showChildElements:@[successMessage]
                   position:MYSFormElementRelativePositionBelow
                   duration:duration
                 completion:completion];
}

- (void)hideSuccessMessageBelowElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    [self hideChildrenOfElements:@[element] type:MYSFormChildElementTypeSuccess completion:completion];
}

- (void)showView:(UIView *)view
      relativeTo:(MYSFormElement *)element
        position:(MYSFormElementRelativePosition)position
      completion:(void (^)(void))completion
{
    MYSFormViewChildElement *viewChildElement = [MYSFormViewChildElement viewChildElementWithView:view parentElement:element];
    [self showChildElements:@[viewChildElement] position:position duration:0 completion:completion];
}

- (void)hideViewRelativeToElement:(MYSFormElement *)element completion:(void (^)(void))completion
{
    [self hideChildrenOfElements:@[element] type:MYSFormChildElementTypeView completion:completion];
}


#pragma mark (properties)

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    for (MYSFormElement *element in self.elements) {
        element.enabled = enabled;
    }
}


#pragma mark - DATASOURCE collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.elements count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MYSFormElement *element = self.elements[section];
    return [[element elementGroup] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *elementGroup = [self.elements[indexPath.section] elementGroup];
    MYSFormElement *element = elementGroup[indexPath.item];
    MYSFormCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([element cellClass]) forIndexPath:indexPath];
    element.cell = cell;
    [element updateCell];
    return cell;
}


#pragma mark - DELEGATE collection view

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.elements count] &&
        [self.formDelegate respondsToSelector:@selector(formViewController:willRemoveElement:cell:)])
    {
        MYSFormElement *element = self.elements[indexPath.section];
        [self.formDelegate formViewController:self willRemoveElement:element cell:cell];
    }
}


#pragma mark - DELEGATE flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue *cachedSize = self.cachedCellSizes[indexPath];
    if (!cachedSize) {
        NSArray *elementGroup = [self.elements[indexPath.section] elementGroup];
        MYSFormElement *element = elementGroup[indexPath.item];

        CGFloat width = (self.fixedWidth > 0 && self.fixedWidth < collectionView.frame.size.width ?
                         self.fixedWidth :
                         collectionView.frame.size.width);
        MYSFormTheme *theme = [element evaluatedTheme];
        CGSize size = (theme.height ?
                       CGSizeMake(width, [theme.height floatValue]) :
                       [[element cellClass] sizeRequiredForElement:element width:width]);
        size.width = width;

        cachedSize = [NSValue valueWithCGSize:size];
        self.cachedCellSizes[indexPath] = cachedSize;
    }
    return [cachedSize CGSizeValue];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    MYSFormElement *element = self.elements[section];
    return [[element evaluatedTheme].padding UIEdgeInsetsValue];
}


#pragma mark - DATASOURCE form element

- (id)modelValueForFormElement:(MYSFormElement *)formElement
{
    if ([self elementHasValidKeyPath:formElement]) {
        return [self.model valueForKeyPath:formElement.modelKeyPath];
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

- (void)formElementNeedsLayout:(MYSFormElement *)formElement
{
    // if it's an element with a dynamic height, reload it
    NSIndexPath *ip = [self indexPathOfElement:formElement];
    if (ip) {
        [self.collectionView reloadItemsAtIndexPaths:@[ip]];
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

- (void)formElement:(MYSFormElement *)formElement didRequestPresentationOfChildView:(UIView *)childView
{
    MYSFormViewChildElement *viewChildElement = [MYSFormViewChildElement viewChildElementWithView:childView parentElement:formElement];
    [self showChildElements:@[viewChildElement] position:MYSFormElementRelativePositionBelow duration:0 completion:nil];
}

- (void)formElement:(MYSFormElement *)formElement didRequestDismissalOfChildView:(UIView *)childView
{
    [self hideChildrenOfElements:@[formElement] type:MYSFormChildElementTypeView completion:nil];
}

- (void)formElement:(MYSFormElement *)formElement didRequestPushOfViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (MYSFormTheme *)formElementFormTheme
{
    return self.theme;
}


#pragma mark - KVO (the model changed)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    for (MYSFormElement *element in self.elements) {
        if ([element.modelKeyPath isEqualToString:keyPath]) {
            if (![[element.cell textInput] isFirstResponder]) {
                NSIndexPath *ip = [self indexPathOfElement:element];
                if (ip.section < [self.collectionView numberOfSections]) {
                    [self.collectionView reloadItemsAtIndexPaths:@[ip]];
                }
            }
            return;
        }
    }
}


#pragma mark - Private

#pragma mark (showing/hiding child elements)

- (void)showChildElements:(NSArray *)childElements
                 position:(MYSFormElementRelativePosition)position
                 duration:(NSTimeInterval)duration
               completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;

    for (MYSFormMessageChildElement *childElement in childElements) {
        if (!childElement.parentElement) {
            childElement.parentElement = (MYSFormElement *)[self.elements firstObject];
        }
    }

    NSMutableArray *indexPathsToInsert  = [NSMutableArray new];

    for (MYSFormMessageChildElement *childElement in childElements) {

        // make sure this child isn't already showing
        NSArray *visibleChildElements = [self childElementsOfParentElement:childElement.parentElement type:childElement.type];
        if ([visibleChildElements containsObject:childElement]) {
            continue;
        }
        
        NSInteger section = [self.elements indexOfObject:childElement.parentElement];
        NSAssert(section != NSNotFound, @"element must be added to the form.");

        childElement.position   = position;
        childElement.dataSource = self;
        childElement.delegate   = self;

        [childElement.parentElement addChildElement:childElement];
        NSInteger newIndex = [[childElement.parentElement elementGroup] indexOfObject:childElement];
        [indexPathsToInsert addObject:[NSIndexPath indexPathForItem:newIndex inSection:section]];

        if (duration > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideChildrenOfElements:@[childElement.parentElement] type:childElement.type completion:nil];
            });
        }
    }

    if ([indexPathsToInsert count] > 0) {
        [self.cachedCellSizes removeAllObjects];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
        } completion:^(BOOL finished) {
//            NSIndexPath *ip = [indexPathsToInsert firstObject];
//            if (ip) [self.collectionView scrollToItemAtIndexPath:ip
//                                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
//                                                        animated:YES];
            if (completion) completion();
        }];
    }
    else {
        if (completion) completion();
    }
}

- (void)hideChildrenOfElements:(NSArray *)elements type:(MYSFormChildElementType)type completion:(void (^)(void))completion
{
    if (!self.collectionView.window) return;

    NSMutableArray *childElements = [NSMutableArray new];
    for (MYSFormElement *element in elements) {
        [childElements addObjectsFromArray:[self childElementsOfParentElement:element type:type]];
    }

    NSMutableArray *indexPathsToRemove = [NSMutableArray new];
    for (MYSFormMessageChildElement *childElement in childElements) {
        NSIndexPath *ip = [self.collectionView indexPathForCell:childElement.cell];
        if (ip) {
            [childElement.parentElement removeChildElement:childElement];
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

- (NSArray *)childElementsOfParentElement:(MYSFormElement *)element type:(MYSFormChildElementType)type
{
    return [[element elementGroup] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MYSFormElement *childElement, NSDictionary *bindings) {
        return ([childElement isKindOfClass:[MYSFormChildElement class]] && [(MYSFormChildElement *)childElement type] == type);
    }]];
}


#pragma mark (keyboard)

- (void)setupKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        CGRect endFrame            = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat animationDuration  = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIEdgeInsets insets        = self.collectionView.contentInset;
        CGPoint offset             = self.collectionView.contentOffset;
        
//        if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
//            self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        insets.bottom = endFrame.size.height;
//        }
//        else {
//            insets.bottom = endFrame.size.width;
//        }
        offset.y += insets.bottom;
        
        [UIView animateWithDuration:animationDuration delay:0 options:(curve << 16) animations:^{
            self.collectionView.contentInset = insets;
//            self.collectionView.contentOffset = offset;
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
        MYSFormElement *element = [self elementContainingView:textField];
        if (element) {
            MYSFormElement *nextElement = [self elementAfter:element];
            if (nextElement) {
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
        UITextField *textField = (UITextField *)[note.object textInput];
        MYSFormElement *element = [self elementContainingView:textField];
        if (element) {
            MYSFormElement *nextElement = [self elementAfter:element];
            if (nextElement) {
                [self attemptToDismissKeyboard];
                [nextElement beginEditing];
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

- (MYSFormElement *)elementAfter:(MYSFormElement *)anElement
{
    BOOL returnNext = NO;
    for (MYSFormElement *element in self.elements) {
        if (!element.isEditable || [element isKindOfClass:[MYSFormChildElement class]]) {
            continue;
        }
        if (returnNext) {
            return element;
        }
        if (element == anElement) {
            returnNext = YES;
        }
    }
    return nil;
}

- (MYSFormElement *)elementContainingView:(UIView *)view
{
    for (MYSFormElement *element in self.elements) {
        if ([view isDescendantOfView:element.cell]) {
            return element;
        }
    }
    return nil;
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

- (void)registerCellForClass:(Class)cellClass
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerElementCellsForReuse
{
    for (MYSFormElement *element in self.elements) {
        [self registerCellForClass:[element cellClass]];
    }

    // register metadata cells
    [self registerCellForClass:[MYSFormMessageChildCell class]];
    [self registerCellForClass:[MYSFormLoadingChildCell class]];

    // register view child cell
    [self.collectionView registerClass:[MYSFormViewChildCell class] forCellWithReuseIdentifier:NSStringFromClass([MYSFormViewChildCell class])];
}

#pragma mark (helpers)

- (NSIndexPath *)indexPathOfElement:(MYSFormElement *)element
{
    NSInteger section = [self.elements indexOfObject:element];
    NSInteger item = [[element elementGroup] indexOfObject:element];
    return [NSIndexPath indexPathForItem:item inSection:section];
}

@end
