//
//  MapViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "MapViewController.h"
#import "Reachability.h"

#define kDateKey @"dateSaved"

@interface MapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property Reachability *internetConnectionReach;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
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

//----------------------------------     Data Persistance    -----------------------------------
#warning ******     Extract to custom class later PLEASE :)     ******
#pragma mark - Data Persistance
- (NSURL *)documentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

- (NSURL *)plist
{
    NSURL *plistPath = [[self documentsDirectory] URLByAppendingPathComponent:@"Photos.plist"];
    return plistPath;
}

- (void)save
{
    // Not saving to harddrive
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.photoFavArray];
    [data writeToURL:[self plist] atomically:YES];  // This is saving a custom Photo class subclassing NSObject
    [defaults setObject:[NSDate date] forKey:kDateKey];
    [defaults synchronize];
}

- (void)load
{
    NSData *data = [NSData dataWithContentsOfURL:[self plist]];
    if (![NSData dataWithContentsOfURL:[self plist]])
    {
        self.photoFavArray = [NSMutableArray new];
    }
    else
    {
        self.photoFavArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }

}


@end
