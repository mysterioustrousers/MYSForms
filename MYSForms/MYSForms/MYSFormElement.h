//
//  MYSFormElement.h
//  MYSForms
//
//  Created by Adam Kirk on 5/3/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormPresenceValidation.h"
#import "MYSFormRegexValidation.h"


@class MYSFormCell;


@protocol MYSFormElementDataSource;
@protocol MYSFormElementDelegate;


/**
 Do not create direct instances of this class. It is meant to be subclassed.
 */
@interface MYSFormElement : NSObject

@property (nonatomic, weak  ) id<MYSFormElementDelegate>   delegate;
@property (nonatomic, weak  ) id<MYSFormElementDataSource> dataSource;
@property (nonatomic, copy  ) NSString                     *modelKeyPath;
@property (nonatomic, strong) MYSFormCell                  *cell;

- (Class)cellClass;

- (void)updateCell;

- (BOOL)isTextInput;

- (void)addFormValidation:(MYSFormValidation *)formValidation;

/**
 Will return either an empty array or an arry of NSError objects that contain `localizedDescription`s of the failure reason.
 */
- (NSArray *)validationErrors;

@end


@protocol MYSFormElementDataSource <NSObject>
- (id)modelValueForFormElement:(MYSFormElement *)formElement;
@end


@protocol MYSFormElementDelegate <NSObject>
- (void)formElement:(MYSFormElement *)formElement valueDidChange:(id)value;
@end