//
//  MYSFormHeadlineElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormHeadlineCell.h"


@interface MYSFormHeadlineCell ()
@property (nonatomic, strong) MYSFormHeadlineCellData *cellData;
@end


@implementation MYSFormHeadlineCell

- (void)populateWithCellData:(MYSFormHeadlineCellData *)cellData
{
    self.headlineLabel.text = cellData.headline;
}

+ (CGSize)sizeRequiredForCellData:(MYSFormHeadlineCellData *)cellData width:(CGFloat)width
{
    width -= [self cellContentInset].left + [self cellContentInset].right;
    CGSize size = [cellData.headline boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
                                                            }
                                                  context:nil].size;
    size.height += 20;

    return size;
}

+ (UIEdgeInsets)cellContentInset
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

@end


@implementation MYSFormHeadlineCellData

- (NSString *)cellIdentifier
{
    static NSString *cellIdentifier = @"HeadlineFormCell";
    return cellIdentifier;
}

- (Class)cellClass
{
    return [MYSFormHeadlineCell class];
}

@end