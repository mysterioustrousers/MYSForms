//
//  MYSFormMapElement.h
//  MYSForms
//
//  Created by Adam Kirk on 7/11/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormElement.h"
#import "MYSFormMapCell.h"
@import MapKit;

@interface MYSFormMapElement : MYSFormElement

/**
 The designated constructor. There are a few different ways to create an `MKCoordinateRegion`, per the MapKit docs.
 */
+ (instancetype)mapElementWithDisplayRegion:(MKCoordinateRegion)region;

/**
 This is the one required value. Tells the map where to display.
 */
@property (nonatomic, assign) MKCoordinateRegion region;

/**
 If you'd like a pin to be dropped at a certain `CLLocationCoordinate2D` location, provide it here. `nil` will drop no pin.
 */
@property (nonatomic, copy) NSValue *droppedPinCoordinates;

/**
 A helpful method that translates miles into map coordinates.
 */
+ (double)coordinatesForMiles:(CGFloat)miles;

@end
