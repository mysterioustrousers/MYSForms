//
//  MYSFormMapCell.m
//  MYSForms
//
//  Created by Adam Kirk on 7/11/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormMapCell.h"
#import "MYSFormMapElement.h"
#import "MYSFormTheme.h"


@implementation MYSFormMapCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled   = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.pitchEnabled  = NO;
}

+ (CGSize)sizeRequiredForElement:(MYSFormMapElement *)element width:(CGFloat)width
{
    UIEdgeInsets insets = [[element evaluatedTheme].contentInsets UIEdgeInsetsValue];
    return CGSizeMake(width, insets.top + 150 + insets.bottom);
}

- (void)populateWithElement:(MYSFormMapElement *)element
{
    [self.mapView setRegion:element.region];
    if (element.droppedPinCoordinates) {
        [self.mapView removeAnnotations:[self.mapView annotations]];
        CLLocationCoordinate2D coord = [element.droppedPinCoordinates MKCoordinateValue];
        MKPointAnnotation *point = [MKPointAnnotation new];
        point.coordinate = coord;
        [self.mapView addAnnotation:point];
    }
    [super populateWithElement:element];
}

@end
