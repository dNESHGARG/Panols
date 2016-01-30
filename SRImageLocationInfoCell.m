//
//  SRImageLocationInfoCell.m
//  Splitarama
//
//  Created by Dinesh Garg on 1/25/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import "SRImageLocationInfoCell.h"
#import <MapKit/MapKit.h>
#import "SRImageMetadata.h"

@interface SRImageLocationInfoCell()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *locationInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinatesLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SRImageLocationInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellWithData:(SRImageMetadata*)metaData {
    if (metaData.coordinates)
        self.coordinatesLabel.text = metaData.coordinates;
    
    CLLocationCoordinate2D location = self.mapView.userLocation.coordinate;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    location.latitude  = [metaData.latitude doubleValue];//37.250556;
    location.longitude = [metaData.longitude doubleValue];//-96.358333;
    
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = location;
    annotationPoint.title = @"Microsoft";
    annotationPoint.subtitle = @"Microsoft's headquarters";
    [self.mapView addAnnotation:annotationPoint];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)locationUpdate:(CLLocation *)location {
    [self.mapView setCenterCoordinate:location.coordinate];
    if ([self.mapView showsUserLocation] == NO) {
        [self.mapView setShowsUserLocation:YES];
    }
}

@end
