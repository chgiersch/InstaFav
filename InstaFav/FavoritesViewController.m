//
//  FavoritesViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "FavoritesViewController.h"

#define kDateKey @"dateSaved"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *photosArray;

@end

@implementation FavoritesViewController

//---------------------------------    View    -------------------------------------
#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];

}



//----------------------------------    Data Persistance    -----------------------------------
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.photosArray writeToURL:[self plist] atomically:YES];
    [defaults setObject:[NSDate date] forKey:kDateKey];
    [defaults synchronize];
}

- (void)load
{
    NSURL *plistPath = [[self documentsDirectory] URLByAppendingPathComponent:@"Photos.plist"];
    self.photosArray = [NSMutableArray arrayWithContentsOfURL:plistPath];
}


@end
