//
//  MYSFormChildElement.h
//  MYSForms
//
//  Created by Adam Kirk on 7/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"


typedef NS_ENUM(NSInteger, MYSFormChildElementType) {
    MYSFormChildElementTypeLoading,
    MYSFormChildElementTypeValidationError,
    MYSFormChildElementTypeError,
    MYSFormChildElementTypeSuccess,
    MYSFormChildElementTypeView,
};


@interface MYSFormChildElement : MYSFormElement

@property (nonatomic, weak) MYSFormElement *parentElement;

@property (nonatomic, readonly) MYSFormChildElementType type;

@end
