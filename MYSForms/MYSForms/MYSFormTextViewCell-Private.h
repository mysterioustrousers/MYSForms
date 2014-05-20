//
//  MYSFormTextViewCellDelegate.h
//  MYSForms
//
//  Created by Adam Kirk on 5/20/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTextViewCell.h"


@protocol MYSFormTextViewCellDelegate;


@interface MYSFormTextViewCell ()
@property (nonatomic, weak) id<MYSFormTextViewCellDelegate> textViewCellDelegate;
@end


@protocol MYSFormTextViewCellDelegate <NSObject>
- (void)textViewFormCell:(MYSFormTextViewCell *)cell textDidChange:(NSString *)text;
@end

