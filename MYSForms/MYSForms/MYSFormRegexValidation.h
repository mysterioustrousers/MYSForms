//
//  MYSFormRegexValidation.h
//  MYSForms
//
//  Created by Adam Kirk on 5/6/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormValidation.h"


/**
 Some common patterns you can use for `matchPattern`.
 */
extern NSString * const MYSFormRegexValidationPatternEmail;
extern NSString * const MYSFormRegexValidationPatternUsername;
extern NSString * const MYSFormRegexValidationPatternPassword;
extern NSString * const MYSFormRegexValidationPatternHex;
extern NSString * const MYSFormRegexValidationPatternSlug;
extern NSString * const MYSFormRegexValidationPatternURL;
extern NSString * const MYSFormRegexValidationPatternIPAddress;


@interface MYSFormRegexValidation : MYSFormValidation

/**
 A convenience constructor that uses the same rules as setting `matchPattern`.
 */
+ (instancetype)regexValidationWithPattern:(NSString *)pattern failedString:(NSString *)failedString;

/**
 Convenient constructor for using `MYSFormValidationPattern…` constants that define a pattern and sane failureString.
 */
+ (instancetype)regexValidationWithName:(NSString *)name;

/**
 You can provide a simple string pattern and we'll create an NSRegularExpression with sane options for you. It will be stored in 
 `matchExpression`.
 */
@property (nonatomic, strong) NSString *matchPattern;

/**
 For more control, you can create and provide the whole expression object yourself.
 */
@property (nonatomic, strong) NSRegularExpression *matchExpression;

/**
 If YES, a nil value will reported as valid. No match will be attempted. Default is NO.
 */
@property (nonatomic, assign, getter=isNilAllowed) BOOL nilAllowed;

/**
 If YES, a nil value or an empty string will be reported as valid. Default is NO.
 */
@property (nonatomic, assign, getter=isBlankAllowed) BOOL blankAllowed;


@end
