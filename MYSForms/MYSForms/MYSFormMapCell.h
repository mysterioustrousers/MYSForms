//
//  MYSFormMapCell.h
//  MYSForms
//
//  Created by Adam Kirk on 7/11/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormCell.h"
@import MapKit;


@interface MYSFormMapCell : MYSFormCell

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
