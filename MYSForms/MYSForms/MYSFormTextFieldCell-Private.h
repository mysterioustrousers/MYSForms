//
//  MYSFormTextFieldCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 5/12/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormImagePickerCell.h"


@protocol MYSFormTextFieldCellDelegate;


@interface MYSFormTextFieldCell ()
@property (nonatomic, weak) id<MYSFormTextFieldCellDelegate> textFieldCellDelegate;
@end


@protocol MYSFormTextFieldCellDelegate <NSObject>
- (void)textFormCell:(MYSFormTextFieldCell *)cell textDidChange:(NSString *)text;
@end

