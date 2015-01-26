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
#import "RemoveActivity.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, RemoveDelegate>

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

//----------------------------------    Collection View Methods   -----------------------------------
#pragma mark - Collection View Methods
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

    NSArray *activityItems = @[photo.image, photo];
    RemoveActivity *unfavoriteActivity = [RemoveActivity new];
    unfavoriteActivity.delegate = self;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[unfavoriteActivity]];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void)didPressRemoveButton:(NSArray *)activityItems
{
    Photo *photo = [activityItems lastObject];
    for (Photo *favPhoto in self.photoFavArray)
    {
        if ([favPhoto.uniqueID isEqualToString:photo.uniqueID])
        {
            [self.photoFavArray removeObject:favPhoto];
            [self.collectionView reloadData];
            [self.dataAccessor saveArrayToFile:self.photoFavArray];
            break;
        }
    }
}

@end
