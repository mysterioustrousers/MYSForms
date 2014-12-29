//
//  MYSFormTokenFieldElement.h
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormTokenFieldCell.h"


@interface MYSFormTokenFieldElement : MYSFormElement

/**
 Create a return a token field element with a custom transformer block that returns a display string
 when called on any item of the model's array.
 */
+ (instancetype)tokenFieldElementWithModelKeyPath:(NSString *)modelKeyPath
           itemDisplayStringValueTransformerBlock:(NSString * (^)(id item))valueTransformerBlock;

@end
