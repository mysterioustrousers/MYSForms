//
//  MYSFormTextInputElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextFieldCell.h"
#import "MYSFormTextFieldElement.h"


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
}

- (void)dealloc
{
    self.textField.delegate = nil;
}



#pragma mark - Public

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
}

- (UIView *)textInput
{
    return self.textField;
}




#pragma mark - DELEGATE text field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];;

    [self.delegate formCell:self valueDidChange:text];

    if (![text isEqualToString:@""] && self.labelCenterYConstraint.constant == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.label.alpha                            = 1;
            self.labelCenterYConstraint.constant        = 12;
            self.textFieldCenterYConstraint.constant    = -8;
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

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MYSFormTextFieldCellDidHitReturnKey object:textField];
    return YES;
}


@end


NSString * const MYSFormTextFieldCellDidHitReturnKey = @"MYSFormTextFieldCellDidHitReturnKey";
