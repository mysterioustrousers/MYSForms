//
//  MYSFormButtonElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormButtonCell.h"


@interface MYSFormButtonCell ()
@property (nonatomic, strong) MYSFormButtonCellData *cellData;
@end


@implementation MYSFormButtonCell

- (void)populateWithCellData:(MYSFormButtonCellData *)cellData
{
    [self.button setTitle:cellData.title forState:UIControlStateNormal];
    [self.button addTarget:cellData.target action:cellData.action forControlEvents:UIControlEventTouchUpInside];
}

+ (CGSize)sizeRequiredForCellData:(id<MYSFormCellDataProtocol>)cellData width:(CGFloat)width
{
    return CGSizeMake(width, 50);
}

+ (UIEdgeInsets)cellContentInset
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

@end


@implementation MYSFormButtonCellData

- (NSString *)cellIdentifier
{
    static NSString *cellIdentifier = @"ButtonFormCell";
    return cellIdentifier;
}

- (Class)cellClass
{
    return [MYSFormButtonCell class];
}

@end