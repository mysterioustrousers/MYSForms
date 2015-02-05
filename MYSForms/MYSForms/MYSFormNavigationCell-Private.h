//
//  MYSFormNavigationCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 1/31/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormNavigationCell.h"

@protocol MYSFormNavigationCellDelegate;


@interface MYSFormNavigationCell ()
@property (nonatomic, weak) id<MYSFormNavigationCellDelegate> navigationCellDelegate;
@end


@protocol MYSFormNavigationCellDelegate <NSObject>
- (void)navigationCellDidTapCell:(MYSFormNavigationCell *)cell;
@end