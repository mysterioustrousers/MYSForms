//
//  MYSFormTokenCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTokenCell.h"

@protocol MYSFormTokenCellDelegate;


@interface MYSFormTokenCell ()
@property (nonatomic, weak) id<MYSFormTokenCellDelegate> tokenCellDelegate;
@end


@protocol MYSFormTokenCellDelegate <NSObject>
- (void)tokenCellDidTapAddToken:(MYSFormTokenCell *)cell;
- (void)tokenCell:(MYSFormTokenCell *)cell didTapToken:(UIControl *)token index:(NSInteger)index;
@end
