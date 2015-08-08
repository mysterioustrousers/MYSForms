//
//  MYSFormPickerElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormPickerElement.h"
#import "MYSFormPickerCell.h"
#import "MYSFormPickerCell-Private.h"


@interface MYSFormPickerElement () <MYSFormPickerCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, copy                    ) NSMutableArray *data;
@property (nonatomic, strong                  ) UIPickerView   *pickerView;
@property (nonatomic, assign, getter=isVisible) BOOL           visible;
@end


@implementation MYSFormPickerElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        _visible                    = NO;
        _data                       = [NSMutableArray new];
        _pickerView                 = [UIPickerView new];
        _pickerView.dataSource      = self;
        _pickerView.delegate        = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _closesOnSelect             = YES;
    }
    return self;
}


#pragma mark - Public

+ (instancetype)pickerElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormPickerElement *element   = [self new];
    element.label                   = label;
    element.modelKeyPath            = modelKeyPath;
    return element;
}

- (void)openPicker
{
    [self.delegate formElement:self didRequestPresentationOfChildView:self.pickerView];
}

- (void)closePicker
{
    [self.delegate formElement:self didRequestDismissalOfChildView:self.pickerView];
}

- (void)setCell:(MYSFormPickerCell *)cell
{
    [super setCell:cell];
    cell.pickerCellDelegate = self;
}

- (BOOL)isEditable
{
    return YES;
}

- (void)setValues:(NSArray *)values
{
    self.data = [values mutableCopy];
    [self.pickerView reloadAllComponents];
}

- (void)addValue:(id)value
{
    [self.data addObject:value];
    [self.pickerView reloadAllComponents];
}


#pragma mark - DELEGATE form cell


#pragma mark - DELEGATE picker cell

- (void)formPickerCellRequestedPicker:(MYSFormPickerCell *)cell
{
    id value = [self currentModelValue];
    NSInteger index = [self.data indexOfObject:value];
    if (index != NSNotFound) {
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
    if (!self.isVisible) {
        self.visible = YES;
        [self.delegate formElement:self didRequestPresentationOfChildView:self.pickerView];
    }
    else {
        self.visible = NO;
        [self.delegate formElement:self didRequestDismissalOfChildView:self.pickerView];
    }
}


#pragma mark - DATASOURCE picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.data count];
}


#pragma mark - DELEGATE picker view

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id value = self.data[row];
    if (self.valueTransformer) {
        value = [self.valueTransformer transformedValue:value];
    }
    return value;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id value = self.data[row];
    [self.delegate formElement:self valueDidChange:value];
    if (self.closesOnSelect) {
        [self closePicker];
    }
}

@end
