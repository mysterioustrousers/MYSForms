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
#import "MYSFormTheme.h"


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
    MYSFormTheme *theme = [element evaluatedTheme];

    UIEdgeInsets insets = [theme.contentInsets UIEdgeInsetsValue];

    width -= insets.left + insets.right;

    // my guess at the padding UITextView adds to it's sides.
    width -= 13;

    NSString *currentModelValue = [element transformedModelValue];
    CGSize size;
    if ([currentModelValue length] > 0) {
        size = [currentModelValue boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{
                                                         NSFontAttributeName : theme.inputTextFont
                                                         }
                                               context:nil].size;
        size.height += 16;
    }
    else {
        size = CGSizeMake(width, 150);
    }
    size.height = ceil(size.height) + insets.top + insets.bottom;

    return size;
}

- (NSString *)valueKeyPath
{
    return @"textView.text";
}

- (void)populateWithElement:(MYSFormTextViewElement *)element
{
    self.textView.font      = [element evaluatedTheme].inputTextFont;
    self.textView.editable  = element.isEditable && element.isEnabled;
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.textView.font      = theme.inputTextFont;
    self.textView.textColor = theme.inputTextColor;
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
