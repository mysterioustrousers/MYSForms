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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake([[self class] cellContentInset].left, ceil(self.bounds.size.height - 5))];
    [path addLineToPoint:CGPointMake(self.frame.size.width - [[self class] cellContentInset].right, ceil(self.bounds.size.height - 5))];
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
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
    [self layoutIfNeeded];
}

- (UIView *)textInput
{
    return self.textField;
}

- (void)didChangeValueAtValueKeyPath
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
    [[NSNotificationCenter defaultCenter] postNotificationName:MYSFormTextFieldCellDidHitReturnKey object:textField];
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
