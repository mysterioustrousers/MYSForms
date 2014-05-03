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

- (void)populateWithCellData:(MYSFormHeadlineCellData *)cellData
{
    self.headlineLabel.text = cellData.headline;
}

@end


@implementation MYSFormHeadlineCellData

- (Class)cellClass
{
    return [MYSFormHeadlineCell class];
}

@end