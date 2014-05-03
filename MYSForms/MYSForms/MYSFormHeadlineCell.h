//
//  MYSFormHeadlineElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@interface MYSFormHeadlineCell : MYSFormCell
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@end


@interface MYSFormHeadlineCellData : NSObject <MYSFormCellDataProtocol>
@property (nonatomic, copy) NSString *headline;
@end

