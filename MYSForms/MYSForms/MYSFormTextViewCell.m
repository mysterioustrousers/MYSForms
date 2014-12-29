//
//  MYSFormTextViewCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/20/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextViewCell.h"
#import "MYSFormTextViewCell-Private.h"
#import "MYSFormTextViewElement.h"


@interface MYSFormTextViewCell () <UITextViewDelegate>
@end


@implementation MYSFormTextViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textView.delegate = self;
}

- (void)dealloc
{
    self.textView.delegate = nil;
}


#pragma mark - Overrides

+ (CGSize)sizeRequiredForElement:(MYSFormTextViewElement *)element width:(CGFloat)width
{

    width -= [self cellContentInset].left + [self cellContentInset].right;

    // my guess at the padding UITextView adds to it's sides.
    width -= 13;

    NSString *currentModelValue = [element currentModelValue];
    CGSize size = [currentModelValue boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{
                                                       NSFontAttributeName : element.font
                                                       }
                                             context:nil].size;
    size.height = ceil(size.height);

    // the top and bottom padding between the edges of the cell and text view
    size.height += 18 + 18;

    return size;
}

- (NSString *)valueKeyPath
{
    return @"textView.text";
}

- (void)populateWithElement:(MYSFormTextViewElement *)element
{
    self.textView.font     = element.font;
    self.textView.editable = element.isEditable && element.isEnabled;
}

- (UIView *)textInput
{
    return self.textView;
}




#pragma mark - DELEGATE text view

- (void)textViewDidChange:(UITextView *)textView
{
    [self.textViewCellDelegate textViewFormCell:self textDidChange:textView.text];
}




@end
