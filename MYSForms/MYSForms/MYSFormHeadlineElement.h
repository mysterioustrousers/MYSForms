//
//  MYSFormHeadlineElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormHeadlineCell.h"


@interface MYSFormHeadlineElement : MYSFormElement

@property (nonatomic, copy) NSString *headline;

+ (instancetype)headlineElementWithHeadline:(NSString *)headline;

@end
