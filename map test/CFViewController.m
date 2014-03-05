//
//  CFViewController.m
//  map test
//
//  Created by Brad on 3/4/14.
//  Copyright (c) 2014 Brad. All rights reserved.
//

#import "CFViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"


#define METERS_PER_MILE 1609.344

@interface CFViewController ()

@property (strong,nonatomic) NSMutableArray *locationsArray;
@property (strong,nonatomic) MKMapView *myMapView;

@end

@implementation CFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.myMapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.myMapView];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude= 47.6097;
    zoomLocation.longitude= -122.3331;
    
     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,3* METERS_PER_MILE, 3*METERS_PER_MILE);
    
    [self.myMapView setRegion:viewRegion animated:YES];
    //self.myMapView.delegate = self;
    
    [self searchForTechCompanies];
}

-(void)searchForTechCompanies
{
    
    NSString *searchString = [NSString stringWithFormat:@"https://opendata.socrata.com/resource/mg7b-2utv.json"];
    
    NSError *error;
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSArray *techArray =[NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    self.locationsArray = [NSMutableArray new];
    
    for (NSDictionary *dictionary in techArray)
    {
        Location *newLocation = [Location new];
        newLocation.name = [dictionary objectForKey:@"company_name"];
        newLocation.address = [[dictionary objectForKey:@"location"] objectForKey:@"human_address"];
        
       NSNumber *longitude = [[dictionary objectForKey:@"location"] objectForKey:@"longitude"];
       NSNumber *latitude = [[dictionary objectForKey:@"location"] objectForKey:@"latitude"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = longitude.doubleValue;
        coordinate.latitude = latitude.doubleValue;
        newLocation.coordinate = coordinate;
        [self.locationsArray addObject:newLocation];
        
        [self.myMapView addAnnotation:newLocation];
    }
    
    NSLog(@"Array: %@",self.locationsArray);

}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[Location class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"hello");
}
@end
