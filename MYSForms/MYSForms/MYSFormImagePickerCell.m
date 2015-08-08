//
//  MYSFormImagePickerCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormImagePickerCell.h"
#import "MYSFormImagePickerElement.h"
#import "MYSFormImagePickerCell-Private.h"
#import "MYSFormTheme.h"


@interface MYSFormImagePickerCell () <UIActionSheetDelegate>
@property (nonatomic, strong) UIImage *placeholderImage;
@end


@implementation MYSFormImagePickerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.backgroundColor = [UIColor darkGrayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.layer.cornerRadius   = self.imageView.bounds.size.width / 2.0;
    self.imageView.layer.masksToBounds  = YES;
}

+ (CGSize)sizeRequiredForElement:(MYSFormImagePickerElement *)element width:(CGFloat)width
{
    UIEdgeInsets insets = [[element evaluatedTheme].contentInsets UIEdgeInsetsValue];
    return CGSizeMake(width, insets.top + 100 + insets.bottom);
}

- (void)modelValueDidChange
{
    if (!self.imageView.image) {
        self.imageView.image = self.placeholderImage;
    }
}




#pragma mark - Public

- (NSString *)valueKeyPath
{
    return @"imageView.image";
}

- (void)populateWithElement:(MYSFormImagePickerElement *)element
{
    self.label.text             = element.label;
    self.userInteractionEnabled = element.isEnabled;
    self.placeholderImage       = element.placeholderImage;
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.label.font         = theme.labelFont;
    self.label.textColor    = theme.labelTextColor;
}



#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender
{
    [self.imagePickerCellDelegate formImagePickerCellWasTapped:self];
}


@end

