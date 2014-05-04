//
//  MYSFormTextInputElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextFieldCell.h"
#import "MYSFormTextFieldElement.h"


@interface MYSFormTextFieldCell ()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textFieldCenterYConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *labelCenterYConstraint;
@end


@implementation MYSFormTextFieldCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.label.alpha = 0;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        if (note.object == self.textField) {
            if (![self.textField.text isEqualToString:@""] && self.labelCenterYConstraint.constant == 0) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.label.alpha = 1;
                    self.labelCenterYConstraint.constant        = 12;
                    self.textFieldCenterYConstraint.constant    = -8;
                    [self layoutIfNeeded];
                }];
            }
            else if ([self.textField.text isEqualToString:@""]) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.label.alpha = 0;
                    self.textFieldCenterYConstraint.constant    = 0;
                    self.labelCenterYConstraint.constant        = 0;
                    [self layoutIfNeeded];
                }];
            }
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Public

- (void)populateWithElement:(MYSFormTextFieldElement *)element
{
    self.label.text                 = element.label;
    self.textField.placeholder      = element.label;
    self.textField.secureTextEntry  = element.isSecure;
    self.textField.keyboardType     = element.keyboardType;
}

- (UIView *)availableTextInput
{
    return self.textField;
}

@end
