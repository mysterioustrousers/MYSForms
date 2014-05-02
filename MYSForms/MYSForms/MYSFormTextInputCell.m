//
//  MYSFormTextInputElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextInputCell.h"


@interface MYSFormTextInputCell ()
@property (nonatomic, strong) MYSFormTextInputCellData *cellData;
@end


@implementation MYSFormTextInputCell

- (void)populateWithCellData:(MYSFormTextInputCellData *)cellData
{
    self.label.text             = cellData.label;
    self.textField.placeholder  = cellData.placeholder;
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


@implementation MYSFormTextInputCellData

- (NSString *)cellIdentifier
{
    static NSString *cellIdentifier = @"TextInputFormCell";
    return cellIdentifier;
}

- (Class)cellClass
{
    return [MYSFormTextInputCell class];
}

@end
