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
    //retrieves array from plish and adds/removes the photo depending on if it's favorited or not
    self.photoFavArray = [self addOrRemove:photo fromFavArray:[self.dataAccessor retrieveArrayFromFile]];
    [self.dataAccessor saveArrayToFile:self.photoFavArray];
    [self.collectionView reloadData];
}

- (NSMutableArray *)addOrRemove: (Photo *)photo fromFavArray: (NSMutableArray *)array
{
    //Goes through all photos in array and compares the Photo object's uniqueID
    for (Photo *favedPhoto in array)
    {
        //If photo has already been favorited
        if ([favedPhoto.uniqueID isEqualToString: photo.uniqueID])
        {
            photo.isFavorite = NO;
            [array removeObject:favedPhoto];
            return array;
        }
    }
    photo.isFavorite = YES;
    [array addObject:photo];
    return array;
}

@end
