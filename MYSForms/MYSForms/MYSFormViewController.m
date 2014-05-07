//
//  MYSFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormViewController.h"
#import "MYSFormCollectionViewSpringyLayout.h"
#import "MYSFormElement.h"
#import "MYSFormErrorElement.h"


@interface MYSFormViewController () <UICollectionViewDelegateFlowLayout,
                                     UITextFieldDelegate,
                                     MYSFormElementDataSource,
                                     MYSFormElementDelegate>
@property (nonatomic, strong) NSMutableArray      *elements;
@property (nonatomic, strong) NSMutableDictionary *cachedCellSizes;
@property (nonatomic, assign) NSUInteger          outstandingValidationErrorCount;
@property (nonatomic, weak)   UIView              *preInterfaceOrientationChangeFirstResponder;
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    self.preInterfaceOrientationChangeFirstResponder = [self currentFirstResponder];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.cachedCellSizes removeAllObjects];
//    [self.collectionView reloadData];
//    [self.preInterfaceOrientationChangeFirstResponder becomeFirstResponder];
}




#pragma mark - Public

- (void)registerElementCellsForReuse
{
    [MYSFormHeadlineCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormFootnoteCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormTextFieldCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormButtonCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormErrorCell registerForReuseWithCollectionView:self.collectionView];
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
    NSArray *elementsCopy = [self.elements copy];

    // remove all existing error elements
    NSMutableArray *indexPathsToRemove = [NSMutableArray new];
    for (MYSFormElement *element in elementsCopy) {
        if ([element isKindOfClass:[MYSFormErrorElement class]]) {
            NSIndexPath *ip = [self.collectionView indexPathForCell:element.cell];
            if (ip) {
                [indexPathsToRemove addObject:ip];
            }
            [self.elements removeObject:element];
        }
    }

    // validate and add any needed form error elements
    BOOL valid = YES;
    NSMutableArray *indexPathsToInsert = [NSMutableArray new];
    for (MYSFormElement *element in elementsCopy) {
        NSArray *validationErrors = [element validationErrors];
        if ([validationErrors count] > 0) {
            valid = NO;
            NSInteger indexOffset = 1;
            for (NSError *error in validationErrors) {
                MYSFormErrorElement *errorFormElement = [MYSFormErrorElement errorFormElementWithError:[error localizedDescription]];
                NSInteger index = [self.elements indexOfObject:element];
                [self addFormElement:errorFormElement atIndex:index + indexOffset];
                NSIndexPath *ip = [NSIndexPath indexPathForItem:index + indexOffset inSection:0];
                [indexPathsToInsert addObject:ip];
                indexOffset++;
            }
        }
    }

    self.outstandingValidationErrorCount = [indexPathsToInsert count];
    [self.cachedCellSizes removeAllObjects];

    [self.collectionView performBatchUpdates:^{
        if ([indexPathsToRemove count] > 0) {
            [self.collectionView deleteItemsAtIndexPaths:indexPathsToRemove];
        }
        if ([indexPathsToInsert count] > 0) {
            [self.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
        }
    } completion:nil];

    return valid;
}


#pragma mark (properties)

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




#pragma mark - (KVO helpers)

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
