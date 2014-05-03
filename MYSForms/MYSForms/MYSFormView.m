//
//  MYSFormViewController.m
//  MYSForms
//
//  Created by Adam Kirk on 5/1/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormView.h"
#import "MYSSpringyCollectionViewFlowLayout.h"
#import "MYSFormHeadlineCell.h"
#import "MYSFormFootnoteCell.h"
#import "MYSFormTextInputCell.h"
#import "MYSFormButtonCell.h"
#import "MYSInputAccessoryView.h"


@interface MYSFormView () <UICollectionViewDataSource,
                                     UICollectionViewDelegate,
                                     UICollectionViewDelegateFlowLayout,
                                     MYSInputAccessoryViewDelegate>
@property (nonatomic, strong) NSMutableArray        *rows;
@property (nonatomic, strong) NSMutableDictionary   *cells;
@property (nonatomic, strong) MYSInputAccessoryView *inputAccessoryView;

// caches
@property (nonatomic, strong) NSMutableDictionary *cachedCellSizes;
@property (nonatomic, strong) NSArray             *cachedSortedTextInputs;
@end


@implementation MYSFormView

- (void)commonInit
{
    self.dataSource = self;
    self.delegate = self;
    self.rows   = [NSMutableArray new];
    self.cells  = [NSMutableDictionary new];
    self.collectionViewLayout = [MYSSpringyCollectionViewFlowLayout new];
    [self configureForm];
    [self setupKeyboardNotifications];
    self.inputAccessoryView = [MYSInputAccessoryView accessoryViewWithDelegate:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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



#pragma mark - Public

- (void)configureForm
{
    // overriden by subclasses
}

- (MYSFormHeadlineCellData *)addHeadlineElementWithString:(NSString *)headline
{
    MYSFormHeadlineCellData *cellData   = [MYSFormHeadlineCellData new];
    cellData.headline                   = headline;
    [self.rows addObject:cellData];
    return cellData;
}

- (MYSFormFootnoteCellData *)addFootnoteElementWithString:(NSString *)footnote
{
    MYSFormFootnoteCellData *cellData   = [MYSFormFootnoteCellData new];
    cellData.footnote                   = footnote;
    [self.rows addObject:cellData];
    return cellData;
}

- (MYSFormTextInputCellData *)addTextInputElementWithModelKeyPath:(NSString *)keyPath
                                                            label:(NSString *)label
                                                     keyboardType:(UIKeyboardType)keyboardType
                                                           secure:(BOOL)secure
{
    MYSFormTextInputCellData *cellData  = [MYSFormTextInputCellData new];
    cellData.modelKeyPath               = keyPath;
    cellData.label                      = label;
    cellData.keyboardType               = keyboardType;
    cellData.secureTextEntry            = secure;
    [self.rows addObject:cellData];
    return cellData;
}

- (MYSFormButtonCellData *)addButtonElementWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    MYSFormButtonCellData *cellData = [MYSFormButtonCellData new];
    cellData.title                  = title;
    cellData.target                 = target;
    cellData.action                 = action;
    [self.rows addObject:cellData];
    return cellData;
}






#pragma mark - DATASOURCE collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.rows count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MYSFormCellDataProtocol> cellData            = self.rows[indexPath.row];
    MYSFormCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[cellData cellIdentifier]
                                                                                                forIndexPath:indexPath];
    [cell populateWithCellData:cellData];
    return cell;
}


#pragma mark - DELEGATE flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue *cachedSize = self.cachedCellSizes[indexPath];
    if (!cachedSize) {
        id<MYSFormCellDataProtocol> cellData = self.rows[indexPath.row];
        CGSize size = [[cellData cellClass] sizeRequiredForCellData:cellData width:self.frame.size.width];
        size.width = collectionView.frame.size.width;
        cachedSize = [NSValue valueWithCGSize:size];
        self.cachedCellSizes[indexPath] = cachedSize;
    }
    return [cachedSize CGSizeValue];
}


#pragma mark - DELEGATE input accessory view

- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressPreviousButton:(UIButton *)button
{
    [[self previousTextInput] becomeFirstResponder];
    [self updatePrevAndNextButtons];
}

- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressNextButton:(UIButton *)button
{
    [[self nextTextInput] becomeFirstResponder];
    [self updatePrevAndNextButtons];
}

- (void)accessoryInputView:(MYSInputAccessoryView *)view didPressDismissButton:(UIButton *)button
{
    [self endEditing:YES];
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
        UIEdgeInsets insets         = self.contentInset;
        insets.bottom               = self.bounds.size.height - endFrame.size.height;
        [UIView animateWithDuration:animationDuration delay:0 options:(curve << 16) animations:^{
            self.contentInset = insets;
        } completion:^(BOOL finished) {
            [self updatePrevAndNextButtons];
        }];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        CGFloat animationDuration   = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve  = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        UIEdgeInsets insets         = self.contentInset;
        insets.bottom               = 0;
        [UIView animateWithDuration:animationDuration delay:0 options:(curve << 16) animations:^{
            self.contentInset = insets;
        } completion:nil];
    }];
}

- (UIView *)nextTextInput
{
    self.cachedSortedTextInputs = nil;
    UIView *currentFirstResponder   = [self currentFirstResponder];
    NSArray *sortedTextInputs       = [self sortedTextInputs];
    if (currentFirstResponder) {
        NSInteger index = [sortedTextInputs indexOfObject:currentFirstResponder];
        if (index < [sortedTextInputs count] - 1) {
            return sortedTextInputs[index + 1];
        }
    }
    return nil;
}

- (UIView *)previousTextInput
{
    self.cachedSortedTextInputs = nil;
    UIView *currentFirstResponder   = [self currentFirstResponder];
    NSArray *sortedTextInputs       = [self sortedTextInputs];
    if (currentFirstResponder) {
        NSInteger index = [sortedTextInputs indexOfObject:currentFirstResponder];
        if (index > 0) {
            return sortedTextInputs[index - 1];
        }
    }
    return nil;
}

- (void)updatePrevAndNextButtons
{
    self.inputAccessoryView.previousButton.enabled  = NO;
    self.inputAccessoryView.nextButton.enabled      = NO;
    UIView *currentFirstResponder                   = [self currentFirstResponder];
    NSArray *sortedTextInputs                       = [self sortedTextInputs];
    NSInteger index                                 = [sortedTextInputs indexOfObject:currentFirstResponder];
    if ([[self sortedTextInputs] indexOfObject:currentFirstResponder] > 0) {
        self.inputAccessoryView.previousButton.enabled = YES;
    }
    if (index < [sortedTextInputs count] - 1) {
        self.inputAccessoryView.nextButton.enabled = YES;
    }
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
    if (!self.cachedSortedTextInputs) {
        NSMutableArray *queue           = [NSMutableArray arrayWithObject:[UIApplication sharedApplication].keyWindow];
        NSMutableArray *allTextInputs   = [NSMutableArray new];
        while ([queue count] > 0) {
            UIView *view = queue[0];
            [queue removeObjectAtIndex:0];
            if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                [allTextInputs addObject:view];
            }
            for (UIView *subview in view.subviews) {
                [queue addObject:subview];
            }
        }
        self.cachedSortedTextInputs = [allTextInputs sortedArrayUsingComparator:^NSComparisonResult(UIView *v1, UIView *v2) {
            CGRect rectInWindow1 = [v1.superview convertRect:v1.frame toView:nil];
            CGRect rectInWindow2 = [v2.superview convertRect:v2.frame toView:nil];
            return rectInWindow1.origin.y < rectInWindow2.origin.y ? NSOrderedAscending : NSOrderedDescending;
        }];
    }
    return self.cachedSortedTextInputs;
}

@end
