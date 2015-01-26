//
//  MapViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "MapViewController.h"
#import "Reachability.h"
#import "SavedDataAccessor.h"
#import "ImagePointAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property Reachability *internetConnectionReach;
@property SavedDataAccessor *dataAccessor;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAvailableFavImagesToMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadAvailableFavImagesToMapView];
}


- (void)loadAvailableFavImagesToMapView
{
    self.dataAccessor = [SavedDataAccessor new];
    self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    if ([self.internetConnectionReach isReachable])
    {
        for (Photo *photo in self.photoFavArray)
        {
            if (photo.coordinate.latitude != 0 && photo.coordinate.longitude != 0)
            {
                ImagePointAnnotation *annotation = [ImagePointAnnotation new];
                annotation.coordinate = photo.coordinate;
                annotation.title = [NSString stringWithFormat:@"User: %@", photo.userName];
                annotation.image = photo.image;


                [self.mapView addAnnotation:annotation];
            }
        }
    }
    else
    {
#warning ****** display something like: "Internet Connection Unavailable" in the View Controller (maybe an AlertView?) ******
        NSLog(@"Internet Unavailable.");
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    ImagePointAnnotation *imageAnnotation = annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:imageAnnotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.image = [self scale:imageAnnotation.image toSize:CGSizeMake(25, 25)];
    
    return pin;
}

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



@end
