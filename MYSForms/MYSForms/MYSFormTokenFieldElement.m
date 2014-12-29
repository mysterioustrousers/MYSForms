//
//  MYSFormTokenFieldElement.m
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTokenFieldElement.h"
#import "MYSFormTokenFieldCell-Private.h"
#import "MYSFormElement-Private.h"
#import "MYSFormValueTransformer.h"


@interface MYSFormTokenFieldElement () <MYSFormTokenFieldCellDelegate>
@end


@implementation MYSFormTokenFieldElement

@synthesize modelKeyPath=_modelKeyPath;
@synthesize valueTransformer=_valueTransformer;

- (instancetype)initWithModelKeyPath:(NSString *)modelKeyPath
itemDisplayStringValueTransformerBlock:(NSString * (^)(id item))valueTransformerBlock
{
    self = [super init];
    if (self) {
        _modelKeyPath = modelKeyPath;
        _valueTransformer = [MYSFormValueTransformer transformerWithBlock:^NSArray *(NSArray *items) {
            NSMutableArray *transformedItems = [NSMutableArray new];
            for (id item in items) {
                [transformedItems addObject:valueTransformerBlock(item)];
            }
            return transformedItems;
        }];
    }
    return self;
}

+ (instancetype)tokenFieldElementWithModelKeyPath:(NSString *)modelKeyPath
           itemDisplayStringValueTransformerBlock:(NSString * (^)(id item))valueTransformerBlock
{
    return [[self alloc] initWithModelKeyPath:modelKeyPath
       itemDisplayStringValueTransformerBlock:valueTransformerBlock];
}

- (void)setCell:(MYSFormTokenFieldCell *)cell
{
    [super setCell:cell];
    cell.tokenFieldCellDelegate = self;
}

- (void)setValueTransformer:(NSValueTransformer *)valueTransformer
{
    [[NSException exceptionWithName:@"MYSFormTokenFieldElementValueTransformerException"
                            reason:(@"The value transformer passed into the initializer is required and the only "
                                    @"transformer allowed for this type of element.")
                          userInfo:nil] raise];
}


#pragma mark - DELEGATE token field cell

- (void)tokenFieldCellDidTapAddToken:(MYSFormTokenFieldCell *)cell
{

}

- (void)tokenFieldCell:(MYSFormTokenFieldCell *)cell didTapTokenAtIndex:(NSInteger)index
{

}

@end
