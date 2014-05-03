//
//  MYSFormButtonElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@interface MYSFormButtonCell : MYSFormCell
@property (nonatomic, weak) IBOutlet UIButton *button;
@end


@interface MYSFormButtonCellData : NSObject <MYSFormCellDataProtocol>
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) id       target;
@property (nonatomic, assign) SEL      action;
@end