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

@interface MapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property Reachability *internetConnectionReach;
@property SavedDataAccessor *dataAccessor;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
    
    if ([self.internetConnectionReach isReachable])
    {
        for (Photo *photo in self.photoFavArray)
        {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
#warning ****** should get some photos that have coordinate information to test this and decide the behavior for photos that don't have that information *****
#warning ****** should also figure out what to do with photos that don't have coordinate information ******
            annotation.coordinate = photo.coordinate;
#warning ****** figure out what we want to print in annotation title, if we even want one. ******
            annotation.title = photo.userName;
            [self.mapView addAnnotation:annotation];
        }
    }
    else
    {
        //display something like: "Internet Connection Unavailable" in the View Controller (maybe an AlertView?)
        NSLog(@"Internet Unavailable.");
    }
}


@end
