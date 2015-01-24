//
//  FavoritesViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Photo.h"
#import "CustomCollectionViewCell.h"

#define kDateKey @"dateSaved"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *photoFavArray;


@end

@implementation FavoritesViewController

//---------------------------------    View    -------------------------------------
#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    // IF photoFavArray doesn't exist (=nil), create new one
    if (!self.photoFavArray)
    {
        self.photoFavArray = [NSMutableArray new];
    }
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self load];
    // IF photoFavArray doesn't exist (=nil), create new one
    if (!self.photoFavArray)
    {
        self.photoFavArray = [NSMutableArray new];
    }
    [self.collectionView reloadData];

}

//----------------------------------    Collection View    -----------------------------------
#pragma mark - Collection View
- (CustomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if ([self.photoFavArray[indexPath.row] isFavorite])
    {
        cell.imageView.image = [self.photoFavArray[indexPath.row] image];
        return cell;
    }
    else
    {
        return cell;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoFavArray.count;
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
    //If there's something in the plist, set photoFavArray to it
    NSData *data = [NSData dataWithContentsOfURL:[self plist]];
    self.photoFavArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

}







@end
