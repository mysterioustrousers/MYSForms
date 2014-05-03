//
//  MYSFormCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

@protocol MYSFormCellDataProtocol;


@interface MYSFormCell : UICollectionViewCell
+ (void)registerForReuseWithCollectionView:(UICollectionView *)collectionView;
+ (CGSize)sizeRequiredForCellData:(id<MYSFormCellDataProtocol>)cellData width:(CGFloat)width;
+ (UIEdgeInsets)cellContentInset;
- (void)populateWithCellData:(id<MYSFormCellDataProtocol>)cellData;
@end


@protocol MYSFormCellDataProtocol <NSObject>
- (Class)cellClass;
@end