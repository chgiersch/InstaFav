//
//  SearchViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "SearchViewController.h"
#import "JSONParser.h"
#import "Photo.h"
#import "CustomCollectionViewCell.h"

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ParserDelegate>

@property NSMutableArray *photosArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//-------------------------------    JSON Parcer Delegate    -----------------------------------
#pragma mark - JSON Parcer
- (void)didFinishJSONSearchWithMutableArray:(NSMutableArray *)mutableArray
{
    self.photosArray = mutableArray;
    [self.collectionView reloadData];
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



@end
