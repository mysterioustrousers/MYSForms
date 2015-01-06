//
//  MYSFormTokenElement.h
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormTokenCell.h"


@interface MYSFormTokenElement : MYSFormElement

/**
 Set this block with the code you want to run when a token is tapped.
 */
@property (nonatomic, copy) void (^didTapTokenBlock)(UIControl *token, NSInteger tokenIndex);

/**
 Set this block with the code you want to run when the add button is tapped.
 */
@property (nonatomic, copy) void (^didTapAddTokenBlock)(UIControl *addButton);

/**
 Create a return a token field element with a custom transformer block that returns a display string
 when called on any item of the model's array.
 */
+ (instancetype)tokenElementWithModelKeyPath:(NSString *)modelKeyPath
                       valueTransformerBlock:(NSString * (^)(id item))valueTransformerBlock;

@end
