//
//  Location.h
//  map test
//
//  Created by Brad on 3/4/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Location : NSObject <MKAnnotation>

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (MKMapItem*)mapItem;

@end
