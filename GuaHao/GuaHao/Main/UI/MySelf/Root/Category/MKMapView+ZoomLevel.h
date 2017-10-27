//
//  MKMapView+ZoomLevel.h
//  GuaHao
//
//  Created by qiye on 16/6/16.
//  Copyright © 2016年 pinjian. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
