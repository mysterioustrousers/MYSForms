//
//  MYSFormTokenElement.m
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTokenElement.h"
#import "MYSFormTokenCell-Private.h"
#import "MYSFormValueTransformer.h"
#import "MYSFormTheme.h"


@interface MYSFormTokenElement () <MYSFormTokenCellDelegate>
@property (nonatomic, strong) NSValueTransformer *displayStringValueTransformer;
@end


@implementation MYSFormTokenElement

@synthesize modelKeyPath=_modelKeyPath;

- (instancetype)initWithModelKeyPath:(NSString *)modelKeyPath
               valueTransformerBlock:(NSString * (^)(id item))valueTransformerBlock
{
    self = [super init];
    if (self) {
        _modelKeyPath = modelKeyPath;
        _displayStringValueTransformer = [MYSFormValueTransformer transformerWithBlock:^id(id value) {
            return valueTransformerBlock(value);
        }];
    }
    return self;
}

+ (instancetype)tokenElementWithModelKeyPath:(NSString *)modelKeyPath
                       valueTransformerBlock:(NSString * (^)(id item))valueTransformerBlock
{
    return [[self alloc] initWithModelKeyPath:modelKeyPath
                        valueTransformerBlock:valueTransformerBlock];
}

- (void)setCell:(MYSFormTokenCell *)cell
{
    [super setCell:cell];
    cell.tokenCellDelegate = self;
}

- (id)transformedModelValue
{
    id value = [super currentModelValue];
    return [self.displayStringValueTransformer transformedValue:value];
}

- (void)configureClassThemeDefaults:(MYSFormTheme *)theme
{
    theme.backgroundColor = [UIColor clearColor];
    theme.padding = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
}


#pragma mark - DELEGATE token field cell

- (void)tokenCellDidTapAddToken:(MYSFormTokenCell *)cell
{
    if (self.didTapAddTokenBlock) self.didTapAddTokenBlock(cell.addButton);
}

- (void)tokenCell:(MYSFormTokenCell *)cell didTapToken:(UIControl *)token index:(NSInteger)index
{
    if (self.didTapTokenBlock) self.didTapTokenBlock(token, index);
}

@end
