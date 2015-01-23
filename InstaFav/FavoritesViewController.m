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
@property NSMutableArray *photosArray;


@end

@implementation FavoritesViewController

//---------------------------------    View    -------------------------------------
#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [NSMutableArray new];
}




//----------------------------------    Collection View    -----------------------------------
#pragma mark - Collection View
- (CustomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if ([self.photosArray[indexPath.row] isFavorite])
    {
        cell.imageView.image = [self.photosArray[indexPath.row] image];
        return cell;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
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
