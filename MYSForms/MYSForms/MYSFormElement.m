//
//  MYSFormElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormElement-Private.h"
#import "MYSFormCell.h"
#import "MYSFormTheme.h"
#import "MYSFormChildElement-Private.h"


@interface MYSFormElement ()
@property (nonatomic, strong) NSMutableSet   *formValidations;
@property (nonatomic, copy  ) void           (^cellConfigurationBlock)(MYSFormCell *cell);
@property (nonatomic, copy  ) NSMutableArray *childElementsAbove;
@property (nonatomic, copy  ) NSMutableArray *childElementsBelow;
@property (nonatomic, strong) MYSFormTheme   *classDefaultTheme;
@end


@implementation MYSFormElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enabled            = YES;
        _formValidations    = [NSMutableSet new];
        _childElementsAbove = [NSMutableArray new];
        _childElementsBelow = [NSMutableArray new];
        _theme              = [MYSFormTheme new];
        _classDefaultTheme  = [MYSFormTheme new];
        [self configureClassDefaultTheme:_classDefaultTheme];
    }
    return self;
}


#pragma mark - Public

- (BOOL)canAddElement
{
    return YES;
}

- (id)currentModelValue
{
    return [self.dataSource modelValueForFormElement:self];
}

- (id)transformedModelValue
{
    id value = [self currentModelValue];

    // transform the value if needed
    if (self.valueTransformer) {
        value = [self.valueTransformer transformedValue:value];
    }

    return value;
}

- (void)setCell:(MYSFormCell *)cell
{
    _cell = cell;
    if (self.cellConfigurationBlock) self.cellConfigurationBlock(cell);
}

- (Class)cellClass
{
    if (_cellClass) {
        return _cellClass;
    }
    return [self defaultCellClass];
}

- (void)configureClassDefaultTheme:(MYSFormTheme *)theme
{

}

- (void)updateCell
{
    [self.cell populateWithElement:self];
    // only apply a theme if they have not subclassed and customized their own cell class.
    if (self.cellClass == [self defaultCellClass]) {
        [self.cell applyTheme:[self evaluatedTheme]];
    }
    if ([self isModelKeyPathValid]) {
        id modelValue = [self transformedModelValue];
        [self.cell setValue:modelValue forKeyPath:[self.cell valueKeyPath]];
        [self.cell modelValueDidChange];
    }
}

- (void)configureCellBlock:(void (^)(id))block
{
    self.cellConfigurationBlock = block;
}

- (BOOL)isEditable
{
    return NO;
}

- (void)beginEditing
{
    
}

- (BOOL)isModelKeyPathValid
{
    BOOL hasKeyPath     = [self.modelKeyPath length] > 0;
    BOOL isNotExcluded  = ![self.modelKeyPath hasPrefix:@"x-"];
    return hasKeyPath && isNotExcluded;
}

- (void)addFormValidation:(MYSFormValidation *)formValidation
{
    [self.formValidations addObject:formValidation];
}

- (NSArray *)validationErrors
{
    NSMutableArray *validationErrors = [NSMutableArray new];
    if ([self.modelKeyPath length] > 0) {
        id value = [self currentModelValue];
        for (MYSFormValidation *formValidation in self.formValidations) {
            NSError *error = [formValidation errorFromValidatingValue:value];
            if (error) {
                [validationErrors addObject:error];
            }
        }
    }
    return validationErrors;
}


#pragma mark (properties)

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self.cell populateWithElement:self];
}


#pragma mark - Private

- (void)addChildElement:(MYSFormChildElement *)childElement
{
    if (childElement.position == MYSFormElementRelativePositionAbove) {
        [self.childElementsAbove addObject:childElement];
    }
    else {
        [self.childElementsBelow addObject:childElement];
    }
}

- (void)removeChildElement:(MYSFormChildElement *)childElement
{
    [self.childElementsAbove removeObject:childElement];
    [self.childElementsBelow removeObject:childElement];
}

- (NSArray *)elementGroup
{
    return [[self.childElementsAbove arrayByAddingObject:self] arrayByAddingObjectsFromArray:self.childElementsBelow];
}

- (MYSFormTheme *)evaluatedTheme
{
    // We start with a theme containing all the global defaults and we overwrite those defaults with values from
    // more and more specific themes values. The precedence is:
    // Global Defaults < Class Defaults < Form Customizations < Element Customizations
    MYSFormTheme *theme = [MYSFormTheme formThemeWithDefaults];
    // first, the element class theme defaults take precedence over the global defaults
    [theme mergeWithTheme:self.classDefaultTheme];
    // next, the values set on the form theme take precedence over the element class defaults
    [theme mergeWithTheme:[self.delegate formElementFormTheme]];
    // finally, the values set on this element's theme are supreme.
    [theme mergeWithTheme:self.theme];
    // we end up with the theme that should be used to style this element.
    return theme;
}

- (Class)defaultCellClass
{
    NSString *className     = NSStringFromClass([self class]);
    NSString *cellClassName = [className stringByReplacingOccurrencesOfString:@"Element" withString:@"Cell"];
    return NSClassFromString(cellClassName);
}

@end
