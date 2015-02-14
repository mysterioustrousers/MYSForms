//
//  MYSFormNavigationElement.h
//  MYSForms
//
//  Created by Adam Kirk on 1/31/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormNavigationCell.h"


@interface MYSFormNavigationElement : MYSFormElement

/**
 The left aligned title of the element.
 */
@property (nonatomic, copy, readonly) NSString *label;

/**
 The block the client provides that produces the view controller to push onto the navigation stack.
 */
@property (nonatomic, copy, readonly) UIViewController *(^destinationViewControllerBlock)(void);

/**
 Create a return a token field element with a block the client provides that produces the 
 view controller to push onto the navigation stack.
 */
+ (instancetype)navigationElementWithLabel:(NSString *)label
            destinationViewControllerBlock:(UIViewController * (^)())destinationViewControllerBlock;

@end
