//
//  MYSFormCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

@class MYSFormElement;


@protocol MYSFormCellDelegate;


@interface MYSFormCell : UICollectionViewCell

@property (nonatomic, weak) id<MYSFormCellDelegate> delegate;

+ (void)registerForReuseWithCollectionView:(UICollectionView *)collectionView;

+ (CGSize)sizeRequiredForElement:(MYSFormElement *)element width:(CGFloat)width;

+ (UIEdgeInsets)cellContentInset;

- (NSString *)valueKeyPath;

- (void)populateWithElement:(MYSFormElement *)element;

- (UIView *)textInput;

@end


@protocol MYSFormCellDelegate <NSObject>
- (void)formCell:(MYSFormCell *)cell valueDidChange:(id)value;
@end