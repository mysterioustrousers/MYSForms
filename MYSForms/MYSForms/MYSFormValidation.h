//
//  MYSFormValidation.h
//  MYSForms
//
//  Created by Adam Kirk on 5/5/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


extern NSString * const MYSFormErrorDomain;


@interface MYSFormValidation : NSObject

@property (nonatomic, copy) NSString *failedString;

+ (instancetype)validationWithFailedString:(NSString *)failedString;

- (NSError *)errorFromValidatingValue:(id)value;

@end
