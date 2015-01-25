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
#import "SavedDataAccessor.h"

#define kDateKey @"dateSaved"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *photoFavArray;
@property SavedDataAccessor *dataAccessor;

@end

@implementation FavoritesViewController

//---------------------------------    View    -------------------------------------
#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataAccessor = [SavedDataAccessor new];
    self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
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
        cell.imageIsFavView.image = [self.photoFavArray[indexPath.row]getIndicatorImage];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.photoFavArray objectAtIndex:indexPath.row];
    if ([self.photoFavArray containsObject:photo])
    {
        photo.isFavorite = NO;
        [self.photoFavArray removeObject:photo];
        [self.dataAccessor saveArrayToFile:self.photoFavArray];
        [self.collectionView reloadData];
    }
    else
    {
        self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
        photo.isFavorite = YES;
        [self.photoFavArray addObject:photo];
        [self.dataAccessor saveArrayToFile:self.photoFavArray];
        [self.collectionView reloadData];
    }
}

@end
