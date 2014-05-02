//
//  MYSFormFootnoteElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCellProtocol.h"


@interface MYSFormFootnoteCell : UICollectionViewCell <MYSFormCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *footnoteLabel;
@end


@interface MYSFormFootnoteCellData : NSObject <MYSFormCellDataProtocol>
@property (nonatomic, copy) NSString *footnote;
@end
