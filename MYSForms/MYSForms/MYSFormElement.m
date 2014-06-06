//
//  MYSFormElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormCell.h"


@interface MYSFormElement ()
@property (nonatomic, strong) NSMutableSet *formValidations;
@property (nonatomic, strong) NSMutableSet *valueTransformers;
@property (nonatomic, copy  ) void         (^cellConfigurationBlock)(MYSFormCell *cell);
@end


@implementation MYSFormElement

- (instancetype)init
{
    self = [super init];
    if (self) {
        _formValidations = [NSMutableSet new];
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

- (void)setCell:(MYSFormCell *)cell
{
    _cell = cell;
    if (self.cellConfigurationBlock) self.cellConfigurationBlock(cell);
}

- (Class)cellClass
{
    NSString *className     = NSStringFromClass([self class]);
    NSString *cellClassName = [className stringByReplacingOccurrencesOfString:@"Element" withString:@"Cell"];
    return NSClassFromString(cellClassName);
}

- (void)updateCell
{
    [self.cell populateWithElement:self];
    if ([self isModelKeyPathValid]) {
        id modelValue = [self.dataSource modelValueForFormElement:self];
        [self.cell setValue:modelValue forKeyPath:[self.cell valueKeyPath]];
        [self.cell didChangeValueAtValueKeyPath];
    }
}

- (void)configureCellBlock:(void (^)(id))block
{
    self.cellConfigurationBlock = block;
}

- (BOOL)isTextInput
{
    return NO;
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
        id value = [self.dataSource modelValueForFormElement:self];
        for (MYSFormValidation *formValidation in self.formValidations) {
            NSError *error = [formValidation errorFromValidatingValue:value];
            if (error) {
                [validationErrors addObject:error];
            }
        }
    }
    return validationErrors;
}

@end
