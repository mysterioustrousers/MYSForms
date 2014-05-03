//
//  MYSFormTextInputElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextInputCell.h"


@interface MYSFormTextInputCell ()
@property (nonatomic, strong)          MYSFormTextInputCellData *cellData;
@property (nonatomic, weak  ) IBOutlet NSLayoutConstraint       *textFieldCenterYConstraint;
@property (nonatomic, weak  ) IBOutlet NSLayoutConstraint       *labelCenterYConstraint;
@end


@implementation MYSFormTextInputCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        if (note.object == self.textField) {
            if (![self.textField.text isEqualToString:@""] && self.labelCenterYConstraint.constant == 0) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.labelCenterYConstraint.constant        = 12;
                    self.textFieldCenterYConstraint.constant    = -8;
                    [self layoutIfNeeded];
                }];
            }
            else if ([self.textField.text isEqualToString:@""]) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.textFieldCenterYConstraint.constant    = 0;
                    self.labelCenterYConstraint.constant        = 0;
                    [self layoutIfNeeded];
                }];
            }
        }
    }];
}

- (void)populateWithCellData:(MYSFormTextInputCellData *)cellData
{
    self.label.text                 = cellData.label;
    self.textField.placeholder      = cellData.label;
    self.textField.secureTextEntry  = cellData.secureTextEntry;
    self.textField.keyboardType     = cellData.keyboardType;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation MYSFormTextInputCellData

- (Class)cellClass
{
    return [MYSFormTextInputCell class];
}

@end
