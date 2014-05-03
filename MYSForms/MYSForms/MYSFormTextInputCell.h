//
//  MYSFormTextInputElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCellProtocol.h"


@interface MYSFormTextInputCell : UICollectionViewCell <MYSFormCellProtocol>
@property (nonatomic, weak) IBOutlet UILabel     *label;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@end


@interface MYSFormTextInputCellData : NSObject <MYSFormCellDataProtocol>
@property (nonatomic, copy                            ) NSString       *modelKeyPath;
@property (nonatomic, copy                            ) NSString       *label;
@property (nonatomic, assign, getter=isSecureTextEntry) BOOL           secureTextEntry;
@property (nonatomic, assign                          ) UIKeyboardType keyboardType;
@end
