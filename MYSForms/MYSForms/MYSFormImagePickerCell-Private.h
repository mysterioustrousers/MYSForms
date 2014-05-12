//
//  MYSFormImagePickerCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 5/12/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//
#import "MYSFormImagePickerCell.h"


@protocol MYSFormImagePickerCellDelegate;


@interface MYSFormImagePickerCell ()
@property (nonatomic, weak) id<MYSFormImagePickerCellDelegate> imagePickerCellDelegate;
@end


@protocol MYSFormImagePickerCellDelegate <NSObject>
- (void)formImagePickerCellWasTapped:(MYSFormImagePickerCell *)cell;
@end