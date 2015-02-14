//
//  MYSFormElement-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 2/3/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSFormElement.h"
#import "MYSFormRelativePosition.h"


@class MYSFormChildElement;


@interface MYSFormElement ()

- (void)addChildElement:(MYSFormChildElement *)childElement;

- (void)removeChildElement:(MYSFormChildElement *)childElement;

/**
 This element and all its child elements sorted top down.
 */
- (NSArray *)elementGroup;

@end
