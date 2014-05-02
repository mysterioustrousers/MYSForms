//
//  MYSFormElementProtocol.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

@protocol MYSFormCellProtocol;


@protocol MYSFormCellDataProtocol <NSObject>
- (NSString *)cellIdentifier;
- (Class<MYSFormCellProtocol>)cellClass;
@end

@protocol MYSFormCellProtocol <NSObject>
- (void)populateWithCellData:(id<MYSFormCellDataProtocol>)cellData;
+ (CGSize)sizeRequiredForCellData:(id<MYSFormCellDataProtocol>)cellData width:(CGFloat)width;
+ (UIEdgeInsets)cellContentInset;
@end