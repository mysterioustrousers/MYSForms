//
//  MYSFormTextInputElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


extern NSString * const MYSFormTextFieldCellDidHitReturnKey;


@interface MYSFormTextFieldCell : MYSFormCell
@property (nonatomic, weak) IBOutlet UILabel     *label;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@end
