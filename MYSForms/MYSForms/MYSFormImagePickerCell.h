//
//  MYSFormImagePickerCell.h
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"

@interface MYSFormImagePickerCell : MYSFormCell

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
