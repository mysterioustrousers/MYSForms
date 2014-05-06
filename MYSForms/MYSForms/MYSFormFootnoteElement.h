//
//  MYSFormFootnoteElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormFootnoteCell.h"


@interface MYSFormFootnoteElement : MYSFormElement
@property (nonatomic, copy) NSString *footnote;
+ (instancetype)footnoteFormElementWithFootnote:(NSString *)footnote;
@end
