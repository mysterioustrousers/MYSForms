//
//  MYSFormTextInputElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextFieldCell.h"
#import "MYSFormTextFieldElement.h"
#import "MYSFormTextFieldCell-Private.h"
#import "MYSFormTheme.h"


@interface MYSFormTextFieldCell () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textFieldCenterYConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *labelCenterYConstraint;
@end


@implementation MYSFormTextFieldCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.label.alpha = 0;
    self.textField.delegate = self;
    [self registerForNotifications];
}

- (void)dealloc
{
    self.textField.delegate = nil;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self layoutLabelAndTextFieldWithText:self.textField.text];
}


#pragma mark - Public

+ (CGSize)sizeRequiredForElement:(MYSFormTextFieldElement *)element width:(CGFloat)width
{
    MYSFormTheme *theme = [element evaluatedTheme];
    UIEdgeInsets insets     = [theme.contentInsets UIEdgeInsetsValue];
    CGSize labelSize        = [element.label sizeWithAttributes:@{ NSFontAttributeName : theme.inputLabelFont }];
    CGSize textFieldSize    = [@"A" sizeWithAttributes:@{ NSFontAttributeName : theme.inputTextFont }];
    CGFloat height          = ceil(labelSize.height) + 7 + ceil(textFieldSize.height) + 7 + insets.top + insets.bottom;
    return CGSizeMake(width, height);
}

- (NSString *)valueKeyPath
{
    return @"textField.text";
}

- (void)populateWithElement:(MYSFormTextFieldElement *)element
{
    self.label.text                 = element.label;
    self.textField.placeholder      = element.label;
    self.textField.secureTextEntry  = element.isSecure;
    self.textField.keyboardType     = element.keyboardType;
    self.textField.enabled          = element.isEnabled;
    [self layoutIfNeeded];
    [super populateWithElement:element];
}

- (void)applyTheme:(MYSFormTheme *)theme
{
    [super applyTheme:theme];
    self.label.font             = theme.inputLabelFont;
    self.label.textColor        = theme.inputLabelColor;
    self.textField.font         = theme.inputTextFont;
    self.textField.textColor    = theme.inputTextColor;
}

- (UIView *)textInput
{
    return self.textField;
}

- (void)modelValueDidChange
{
    if (self.window) {
        [self layoutLabelAndTextFieldWithText:self.textField.text];
    }
}


#pragma mark - DELEGATE text field

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];;
//    [self.textFieldCellDelegate textFormCell:self textDidChange:text];
//    [self layoutLabelAndTextFieldWithText:text];
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MYSFormTextFieldCellDidHitReturnKey object:self];
    return YES;
}


#pragma mark - Notifications

- (void)textFieldDidChange:(NSNotification *)note
{
    NSString *text = self.textField.text;
    [self.textFieldCellDelegate textFormCell:self textDidChange:text];
    [self layoutLabelAndTextFieldWithText:text];
}


#pragma mark - Private

- (void)layoutLabelAndTextFieldWithText:(NSString *)text
{
    CGFloat labelHeight = [self.label.text sizeWithAttributes:@{ NSFontAttributeName : self.label.font }].height + 4;
    CGFloat textFieldHeight = [text sizeWithAttributes:@{ NSFontAttributeName : self.textField.font }].height + 4;
    CGFloat totalHeight = (labelHeight + 5 + textFieldHeight) - 4;
    CGFloat topAndBottomPadding = (self.bounds.size.height - totalHeight) / 2.0;
    CGFloat labelDeltaY = CGRectGetMidY(self.label.frame) - topAndBottomPadding - (self.label.frame.size.height / 2.0);
    CGFloat textFieldDeltaY = CGRectGetMidY(self.textField.frame) - topAndBottomPadding - (self.textField.frame.size.height / 2.0);
    if (![text isEqualToString:@""] && self.labelCenterYConstraint.constant == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.label.alpha                            = 1;
            self.labelCenterYConstraint.constant        = labelDeltaY;
            self.textFieldCenterYConstraint.constant    = -textFieldDeltaY;
            [self layoutIfNeeded];
        }];
    }
    else if ([text isEqualToString:@""]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.label.alpha                            = 0;
            self.textFieldCenterYConstraint.constant    = 0;
            self.labelCenterYConstraint.constant        = 0;
            [self layoutIfNeeded];
        }];
    }
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textField];
}

@end


NSString * const MYSFormTextFieldCellDidHitReturnKey = @"MYSFormTextFieldCellDidHitReturnKey";
