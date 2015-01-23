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

#define kDateKey @"dateSaved"

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ParserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *photosArray;
@property NSMutableArray *photoFavArray;

@property NSString *hashtag;

@end


@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [NSMutableArray new];
    if (!self.photoFavArray)
    {
        self.photoFavArray = [NSMutableArray new];
    }
    JSONParser *parser = [JSONParser new];
    self.hashtag = @"cats";
    parser.delegate = self;
    [parser getImagesFromHashtagSearch:self.hashtag];

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

    Photo *photo = self.photosArray[indexPath.item];
    cell.imageView.image = photo.image;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.photosArray objectAtIndex:indexPath.row];
    if ([self.photoFavArray containsObject:photo])
    {
        [self load];
        photo.isFavorite = NO;
        [self.photoFavArray removeObject:photo];
        [self save];
    }
    else
    {
        [self load];
        photo.isFavorite = YES;
        [self.photoFavArray addObject:photo];
        [self save];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

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
    [self.photoFavArray writeToURL:[self plist] atomically:YES];
    [defaults setObject:[NSDate date] forKey:kDateKey];
    [defaults synchronize];
}

- (void)load
{
    NSURL *plistPath = [[self documentsDirectory] URLByAppendingPathComponent:@"Photos.plist"];
    self.photoFavArray = [NSMutableArray arrayWithContentsOfURL:plistPath];
}



@end
