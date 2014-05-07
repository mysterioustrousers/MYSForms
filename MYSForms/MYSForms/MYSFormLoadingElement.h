//
//  MYSFormLoadingElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormLoadingCell.h"


@interface MYSFormLoadingElement : MYSFormElement
@property (nonatomic, weak) MYSFormElement *parentFormElement;
+ (instancetype)loadingFormElementWithParentFormElement:(MYSFormElement *)parentFormElement;
@end
