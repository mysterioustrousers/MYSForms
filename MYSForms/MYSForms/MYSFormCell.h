//
//  MYSFormCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

@class MYSFormElement;
@class MYSFormTheme;


@interface MYSFormCell : UICollectionViewCell

+ (CGSize)sizeRequiredForElement:(MYSFormElement *)element width:(CGFloat)width;

- (NSString *)valueKeyPath;

- (void)populateWithElement:(MYSFormElement *)element;

- (void)applyTheme:(MYSFormTheme *)theme;

- (UIView *)textInput;

- (void)modelValueDidChange;

@end
