//
//  MYSFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormViewController.h"
#import "MYSFormElement.h"
#import "MYSSpringyCollectionViewFlowLayout.h"
#import "MYSFormHeadlineCell.h"
#import "MYSFormFootnoteCell.h"
#import "MYSFormTextFieldCell.h"
#import "MYSFormButtonCell.h"


@interface MYSFormViewController () <UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray      *rows;
@property (nonatomic, strong) NSMutableDictionary *cells;
@property (nonatomic, strong) NSMutableDictionary *cachedCellSizes;
@end


@implementation MYSFormViewController

- (void)commonInit
{
    self.rows   = [NSMutableArray new];
    self.cells  = [NSMutableDictionary new];
    [self setupDefaults];
    [self configureForm];
}

- (instancetype)init
{
    self = [super initWithCollectionViewLayout:[MYSSpringyCollectionViewFlowLayout new]];
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

    [self setupKeyboardNotifications];

    [MYSFormHeadlineCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormFootnoteCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormTextFieldCell registerForReuseWithCollectionView:self.collectionView];
    [MYSFormButtonCell registerForReuseWithCollectionView:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top += self.collectionView.frame.size.height;
    self.collectionView.contentInset = insets;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top -= self.collectionView.frame.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.contentInset = insets;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[self sortedTextInputs] firstObject] becomeFirstResponder];
        });
    }];
}


#pragma mark - Public

- (void)configureForm
{
    // overriden by subclasses
}

- (void)addFormElement:(MYSFormElement *)element
{
    [self.rows addObject:element];
}


#pragma mark - DATASOURCE collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.rows count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYSFormElement *element = self.rows[indexPath.row];
    MYSFormCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([element cellClass]) forIndexPath:indexPath];
    [cell populateWithElement:element];

    if ([cell availableTextInput]) {
        UITextField *textInput = (UITextField *)[cell availableTextInput];
        textInput.delegate = self;
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
        MYSFormElement *element = self.rows[indexPath.row];
        CGSize size = [[element cellClass] sizeRequiredForElement:element width:collectionView.frame.size.width];
        size.width = collectionView.frame.size.width;
        cachedSize = [NSValue valueWithCGSize:size];
        self.cachedCellSizes[indexPath] = cachedSize;
    }
    return [cachedSize CGSizeValue];
}


#pragma mark - DELEGATE text field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *nextTextInput = [self textInputAfter:textField];
    if (nextTextInput) {
        [nextTextInput becomeFirstResponder];
    }
    else {
        [self.formDelegate formViewControllerReturnKeyPressedOnLastField:self];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self textInputAfter:textField]) {
        textField.returnKeyType = UIReturnKeyNext;
    }
    else {
        textField.returnKeyType = self.lastFieldReturnKeyType;
    }
    return YES;
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
        insets.bottom               = self.collectionView.bounds.size.height - endFrame.size.height;
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
}

- (void)setupDefaults
{
    self.lastFieldReturnKeyType = UIReturnKeyDone;
}

#pragma mark (text input)

- (UIView *)textInputAfter:(UIView *)textInput
{
    NSArray *textInputs = [self sortedTextInputs];
    NSInteger index     = [textInputs indexOfObject:textInput];
    if (index < [textInputs count] - 1) {
        return textInputs[index + 1];
    }
    return nil;
}

- (UIView *)textInputBefore:(UIView *)textInput
{
    NSArray *textInputs = [self sortedTextInputs];
    NSInteger index     = [textInputs indexOfObject:textInput];
    if (index > 0) {
        return textInputs[index - 1];
    }
    return nil;
}

- (UIView *)currentFirstResponder
{
    for (UIView *view in [self sortedTextInputs]) {
        if ([view isFirstResponder]) {
            return view;
        }
    }
    return nil;
}

- (NSArray *)sortedTextInputs
{
    NSArray *visibleCells           = [self.collectionView visibleCells];
    NSMutableArray *textInputs      = [NSMutableArray new];
    for (MYSFormCell *cell in visibleCells) {
        UIView *textInput = [cell availableTextInput];
        if (textInput) {
            [textInputs addObject:textInput];
        }
    }
    return [textInputs sortedArrayUsingComparator:^NSComparisonResult(UIView *v1, UIView *v2) {
        CGRect rectInWindow1 = [v1.superview convertRect:v1.frame toView:nil];
        CGRect rectInWindow2 = [v2.superview convertRect:v2.frame toView:nil];
        return rectInWindow1.origin.y < rectInWindow2.origin.y ? NSOrderedAscending : NSOrderedDescending;
    }];
}

//- (NSArray *)viewsThatCanBeDisabled
//{
//    return [[self allViewsOfForm] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *view, NSDictionary *bindings) {
//        return [view respondsToSelector:@selector(setEnabled:)];
//    }]];
//}
//
//- (NSArray *)allViewsOfForm
//{
//    NSMutableOrderedSet *allViews   = [NSMutableOrderedSet orderedSetWithObject:self.collectionView];
//    NSInteger index                 = 0;
//    while (index < [allViews count]) {
//        UIView *view = allViews[index++];
//        [allViews addObjectsFromArray:view.subviews];
//    }
//    return [allViews array];
//}

@end
