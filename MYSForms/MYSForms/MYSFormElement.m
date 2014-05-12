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

- (Class)cellClass
{
    NSString *className     = NSStringFromClass([self class]);
    NSString *cellClassName = [className stringByReplacingOccurrencesOfString:@"Element" withString:@"Cell"];
    return NSClassFromString(cellClassName);
}

- (void)updateCell
{
    [self.cell populateWithElement:self];
    if ([self.modelKeyPath length] > 0 && [[self.cell valueKeyPath] length] > 0) {
        id modelValue = [self.dataSource modelValueForFormElement:self];
        [self.cell setValue:modelValue forKeyPath:[self.cell valueKeyPath]];
    }
}

- (BOOL)isTextInput
{
    return NO;
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
