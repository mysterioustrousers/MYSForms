//
//  MYSFormCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

@class MYSFormElement;


@interface MYSFormCell : UICollectionViewCell

+ (CGSize)sizeRequiredForElement:(MYSFormElement *)element width:(CGFloat)width;

+ (UIEdgeInsets)cellContentInset;

- (NSString *)valueKeyPath;

- (void)populateWithElement:(MYSFormElement *)element;

- (UIView *)textInput;

@end
