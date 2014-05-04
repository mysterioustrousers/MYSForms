//
//  MYSFormElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


/**
 Do not create direct instances of this class. It is meant to be subclassed.
 */
@interface MYSFormElement : NSObject

@property (nonatomic, copy) NSString *modelKeyPath;

- (Class)cellClass;

@end
