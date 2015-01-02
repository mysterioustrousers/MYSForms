//
//  MYSFormViewChildCell.m
//  MYSForms
//
//  Created by Adam Kirk on 7/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormViewChildCell.h"
#import "MYSFormViewChildElement.h"


@interface MYSFormViewChildCell ()
@property (nonatomic, weak) MYSFormViewChildElement *element;
@end


@implementation MYSFormViewChildCell

+ (CGSize)sizeRequiredForElement:(MYSFormViewChildElement *)element width:(CGFloat)width
{
    return element.view.bounds.size;
}

- (void)populateWithElement:(MYSFormViewChildElement *)element
{
    self.element        = element;
    UIView *view        = element.view;
    UIView *contentView = self.contentView;

    for (UIView *view in contentView.subviews) {
        [view removeFromSuperview];
    }

    [view setTranslatesAutoresizingMaskIntoConstraints:NO];

    [contentView addSubview:view];

    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];

    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0]];

    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1
                                                             constant:0]];

    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:0]];

    [super populateWithElement:element];
}

@end
