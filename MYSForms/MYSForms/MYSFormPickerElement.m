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
@property (nonatomic, copy  ) NSMutableArray *data;
@property (nonatomic, strong) UIPickerView   *pickerView;
@end


@implementation MYSFormPickerElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
        _pickerView                 = [UIPickerView new];
        _pickerView.dataSource      = self;
        _pickerView.delegate        = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}




#pragma mark - Public

+ (instancetype)pickerElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormPickerElement *element   = [MYSFormPickerElement new];
    element.label                   = label;
    element.modelKeyPath            = modelKeyPath;
    return element;
}

- (void)setCell:(MYSFormPickerCell *)cell
{
    [super setCell:cell];
    cell.pickerCellDelegate = self;
}

- (void)setValues:(NSArray *)values
{
    NSMutableArray *newData = [NSMutableArray new];
    for (id value in values) {
        id transformedValue = value;
        if (self.valueTransformer) {
            transformedValue = [self.valueTransformer transformedValue:value];
        }
        [newData addObject:transformedValue];
    }
    self.data = newData;
    [self.pickerView reloadAllComponents];
}

- (void)addValue:(id)value
{
    if (self.valueTransformer) {
        value = [self.valueTransformer transformedValue:value];
    }
    [self.data addObject:value];
    [self.pickerView reloadAllComponents];
}



#pragma mark - DELEGATE form cell




#pragma mark - DELEGATE picker cell

- (void)formPickerCellRequestedPicker:(MYSFormPickerCell *)cell
{
    id value = [self.dataSource modelValueForFormElement:self];
    NSInteger index = [self.data indexOfObject:value];
    if (index != NSNotFound) {
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
    [self.delegate formElement:self didRequestPresentationOfPickerView:self.pickerView];
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
    return self.data[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id value = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.delegate formElement:self valueDidChange:value];
}


@end
