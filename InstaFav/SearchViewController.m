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

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ParserDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *photosArray;
@property NSMutableArray *photoFavArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSString *hashtag;
@property JSONParser *parser;

@end


@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [NSMutableArray new];
    [self load];
    self.parser = [JSONParser new];

    //Default search is "cats". ^_^
    self.hashtag = @"cats";
    self.parser.delegate = self;
    [self.parser getImagesFromHashtagSearch:self.hashtag];
    [self.spinner startAnimating];

}


//-----------------------------    Search Bar Delegate Method    -----------------------------------
#pragma mark - Search Bar Delegate Method
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *searchTermWithoutWhitespaces = [searchTerm stringByTrimmingCharactersInSet: set];
    //only do a search if searchTerm does not consist of only whitespace
    if (searchTermWithoutWhitespaces != 0)
    {
        [self.spinner startAnimating];
        [self.parser getImagesFromHashtagSearch:searchTermWithoutWhitespaces];
        [searchBar resignFirstResponder];
    }
}

//-------------------------------    JSON Parser Delegate    -----------------------------------
#pragma mark - JSON Parser
- (void)didFinishJSONSearchWithMutableArray:(NSMutableArray *)mutableArray
{
    [self.spinner stopAnimating];
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
    cell.imageIsFavView.image = [photo getIndicatorImage];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.photosArray objectAtIndex:indexPath.row];
#warning ******  Should probably search the ids instead, since every time we parse the JSON we create new Photo items, so this wouldn't work with hashtags that have fewer than 10 images ********
    if ([self.photoFavArray containsObject:photo])
    {
        photo.isFavorite = NO;
        [self.photoFavArray removeObject:photo];
        [self save];
        [self.collectionView reloadData];
    }
    else
    {
        [self load];
        photo.isFavorite = YES;
        [self.photoFavArray addObject:photo];
        [self save];
        [self.collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photosArray.count < 10)
    {
        return self.photosArray.count;
    }
    else
    {
        return 10;
    }
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
