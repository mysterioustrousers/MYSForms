//
//  MYSFormToggleCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 5/14/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


@protocol MYSFormToggleCellDelegate;


@interface MYSFormToggleCell ()
@property (nonatomic, weak) id<MYSFormToggleCellDelegate> toggleCellDelegate;
@end


@protocol MYSFormToggleCellDelegate <NSObject>
- (void)toggleCell:(MYSFormToggleCell *)cell didToggleOn:(BOOL)isOn;
@end