//
//  MYSFormTokenFieldCell-Private.h
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTokenFieldCell.h"

@protocol MYSFormTokenFieldCellDelegate;


@interface MYSFormTokenFieldCell ()
@property (nonatomic, weak) id<MYSFormTokenFieldCellDelegate> tokenFieldCellDelegate;
@end


@protocol MYSFormTokenFieldCellDelegate <NSObject>
- (void)tokenFieldCellDidTapAddToken:(MYSFormTokenFieldCell *)cell;
- (void)tokenFieldCell:(MYSFormTokenFieldCell *)cell didTapToken:(UIControl *)token index:(NSInteger)index;
@end
