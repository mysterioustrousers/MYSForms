//
//  MYSFormCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@implementation MYSFormCell

+ (void)registerForReuseWithCollectionView:(UICollectionView *)collectionView
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass(self)];
}

+ (CGSize)sizeRequiredForCellData:(id<MYSFormCellDataProtocol>)cellData width:(CGFloat)width
{
    return CGSizeMake(width, 50);
}

+ (UIEdgeInsets)cellContentInset
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (void)populateWithCellData:(id<MYSFormCellDataProtocol>)cellData
{
    // used by subclasses
}

@end
