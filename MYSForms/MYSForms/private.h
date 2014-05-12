//
//  private.h
//  MYSForms
//
//  Created by Adam Kirk on 5/7/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormMessageElement.h"


@protocol MYSFormElementDataSource;
@protocol MYSFormElementDelegate;


@interface MYSFormElement ()
@property (nonatomic, weak) id<MYSFormElementDelegate>   delegate;
@property (nonatomic, weak) id<MYSFormElementDataSource> dataSource;
@end


@protocol MYSFormElementDataSource <NSObject>
- (id)modelValueForFormElement:(MYSFormElement *)formElement;
@end


@protocol MYSFormElementDelegate <NSObject>
- (void)formElement:(MYSFormElement *)formElement valueDidChange:(id)value;
@end


