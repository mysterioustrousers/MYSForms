//
//  MYSFormRegexValidation.m
//  MYSForms
//
//  Created by Adam Kirk on 5/6/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormRegexValidation.h"

@implementation MYSFormRegexValidation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nilAllowed     = NO;
        self.blankAllowed   = NO;
    }
    return self;
}

- (NSString *)failedString
{
    return [super failedString] ?: @"Invalid Format.";
}

- (NSError *)errorFromValidatingValue:(id)value;
{
    if (self.nilAllowed && value == nil) {
        return nil;
    }
    else if (value == nil) {
        return [self errorWithString:self.failedString];
    }

    NSAssert([value isKindOfClass:[NSString class]], @"Value must be a string to perform regex validation.");

    if (self.blankAllowed && [value length] == 0) {
        return nil;
    }
    else if ([value length] == 0) {
        return [self errorWithString:self.failedString];
    }

    if ([self.matchExpression numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0) {
        return nil;
    }
    else {
        return [self errorWithString:self.failedString];
    }
}




#pragma mark - Public

+ (instancetype)regexValidationWithPattern:(NSString *)pattern failedString:(NSString *)failedString
{
    MYSFormRegexValidation *validation = [MYSFormRegexValidation validationWithFailedString:failedString];
    validation.matchPattern = pattern;
    return validation;
}

+ (instancetype)regexValidationWithName:(NSString *)name
{
    MYSFormRegexValidation *validation = [MYSFormRegexValidation new];
    validation.matchPattern = name;
    return validation;
}

- (void)setMatchPattern:(NSString *)matchPattern
{
    _matchPattern = matchPattern;

    [self attemptToSetUserFriendlyFailureStringFromPattern:matchPattern];

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:matchPattern
                                                                           options:(NSRegularExpressionCaseInsensitive |
                                                                                    NSRegularExpressionDotMatchesLineSeparators)
                                                                             error:&error];

    NSAssert(error == nil, @"Could not create regulare expression with pattern string: %@", [error localizedDescription]);

    self.matchExpression = regex;
}

- (void)setMatchExpression:(NSRegularExpression *)matchExpression
{
    _matchExpression = matchExpression;
    [self attemptToSetUserFriendlyFailureStringFromPattern:[matchExpression pattern]];
}




#pragma mark - Private

- (void)attemptToSetUserFriendlyFailureStringFromPattern:(NSString *)pattern
{
    if ([pattern isEqualToString:MYSFormRegexValidationPatternEmail]) {
        self.failedString = @"Must be a valid E-mail Address.";
    }
}

- (NSError *)errorWithString:(NSString *)string
{
    return [NSError errorWithDomain:MYSFormErrorDomain
                               code:1
                           userInfo:@{ NSLocalizedDescriptionKey : string,
                                       NSLocalizedFailureReasonErrorKey : string }];
}


@end


NSString * const MYSFormRegexValidationPatternEmail     = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
NSString * const MYSFormRegexValidationPatternUsername  = @"^[a-z0-9_-]{3,16}$";
NSString * const MYSFormRegexValidationPatternPassword  = @"^[a-z0-9_-]{6,18}$";
NSString * const MYSFormRegexValidationPatternHex       = @"^#?([a-f0-9]{6}|[a-f0-9]{3})$";
NSString * const MYSFormRegexValidationPatternSlug      = @"^[a-z0-9-]+$";
NSString * const MYSFormRegexValidationPatternURL       = @"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$";
NSString * const MYSFormRegexValidationPatternIPAddress = @"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";

