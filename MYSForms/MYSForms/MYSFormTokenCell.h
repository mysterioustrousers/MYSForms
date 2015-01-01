//
//  MYSFormTokenCell.h
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"


@interface MYSFormTokenCell : MYSFormCell


@property (nonatomic, strong) IBOutlet UIButton *addButton;

@property (nonatomic, copy, readonly) NSArray *tokenControls;

/**
 The value this view displays. For each string, an NSControl is created and
 added to the cell to display the string in a token/tag (bubble by default) form.
 */
@property (nonatomic, copy) NSArray *tokenDisplayStrings;

/**
 This can be overriden by customizing subclasses to provide the UIControl views
 that will be used for the tokens. 
 Note: The view's frame should be set so that it can be used for layout.
 */
- (UIControl *)controlForTokenWithText:(NSString *)text;

@end
