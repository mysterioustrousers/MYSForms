//
//  MYSFormFootnoteElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormFootnoteCell.h"


@interface MYSFormFootnoteCell ()
@property (nonatomic, strong) MYSFormFootnoteCellData *cellData;
@end


@implementation MYSFormFootnoteCell

- (void)populateWithCellData:(MYSFormFootnoteCellData *)cellData
{
    self.footnoteLabel.text = cellData.footnote;
}

+ (CGSize)sizeRequiredForCellData:(MYSFormFootnoteCellData *)cellData width:(CGFloat)width
{
    width -= [self cellContentInset].left + [self cellContentInset].right;


    CGSize size = [cellData.footnote boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
                                                            }
                                                  context:nil].size;
    return size;
}

+ (UIEdgeInsets)cellContentInset
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

@end


@implementation MYSFormFootnoteCellData

- (NSString *)cellIdentifier
{
    static NSString *cellIdentifier = @"FootnoteFormCell";
    return cellIdentifier;
}

- (Class)cellClass
{
    return [MYSFormFootnoteCell class];
}

@end