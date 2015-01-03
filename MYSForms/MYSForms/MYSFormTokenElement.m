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


@interface MYSFormTokenElement () <MYSFormTokenCellDelegate>
@end


@implementation MYSFormTokenElement

@synthesize modelKeyPath=_modelKeyPath;
@synthesize valueTransformer=_valueTransformer;

- (instancetype)initWithModelKeyPath:(NSString *)modelKeyPath
        forwardValueTransformerBlock:(NSString * (^)(id item))forwardValueTransformerBlock
        reverseValueTransformerBlock:(id (^)(NSString *tokenText))reverseValueTransformerBlock;
{
    self = [super init];
    if (self) {
        _modelKeyPath = modelKeyPath;
        _valueTransformer = [MYSFormValueTransformer reversibleTransformerWithForwardBlock:^id(id value) {
            if ([value respondsToSelector:@selector(count)]) {
                NSMutableArray *transformedItems = [NSMutableArray new];
                for (id item in value) {
                    [transformedItems addObject:forwardValueTransformerBlock(item)];
                }
                return transformedItems;
            }
            else {
                return forwardValueTransformerBlock(value);
            }
        } reverseBlock:^id(id value) {
            if ([value respondsToSelector:@selector(count)]) {
                NSMutableArray *transformedItems = [NSMutableArray new];
                for (id item in value) {
                    [transformedItems addObject:reverseValueTransformerBlock(item)];
                }
                return transformedItems;
            }
            else {
                return reverseValueTransformerBlock(value);
            }
        }];
    }
    return self;
}

+ (instancetype)tokenElementWithModelKeyPath:(NSString *)modelKeyPath
                forwardValueTransformerBlock:(NSString * (^)(id item))forwardValueTransformerBlock
                reverseValueTransformerBlock:(id (^)(NSString *tokenText))reverseValueTransformerBlock;
{
    return [[self alloc] initWithModelKeyPath:modelKeyPath
            forwardValueTransformerBlock:forwardValueTransformerBlock
                 reverseValueTransformerBlock:reverseValueTransformerBlock];
}

- (void)setCell:(MYSFormTokenCell *)cell
{
    [super setCell:cell];
    cell.tokenCellDelegate = self;
}


#pragma mark - MYSFormElement

- (void)setValueTransformer:(NSValueTransformer *)valueTransformer
{
    [[NSException exceptionWithName:@"MYSFormTokenElementValueTransformerException"
                            reason:(@"The value transformer passed into the initializer is required and the only "
                                    @"transformer allowed for this type of element.")
                          userInfo:nil] raise];
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
