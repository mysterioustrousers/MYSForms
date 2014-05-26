//
//  MYSFormFootnoteElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormFootnoteCell.h"
#import "MYSFormFootnoteElement.h"


@implementation MYSFormFootnoteCell

+ (CGSize)sizeRequiredForElement:(MYSFormFootnoteElement *)element width:(CGFloat)width
{
    width -= [self cellContentInset].left + [self cellContentInset].right;
    CGSize size = [element.footnote boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
                                                            }
                                                  context:nil].size;
    size.height = ceil(size.height);

    size.height += 10;

    return size;
}

- (void)populateWithElement:(MYSFormFootnoteElement *)element
{
    self.footnoteLabel.text = element.footnote;
    [super populateWithElement:element];
}

@end

