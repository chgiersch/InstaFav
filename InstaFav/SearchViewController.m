//
//  SearchViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "SearchViewController.h"
#import "Reachability.h"
#import "JSONParser.h"
#import "Photo.h"
#import "CustomCollectionViewCell.h"
#import "SavedDataAccessor.h"

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ParserDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property NSMutableArray *photosArray;
@property NSMutableArray *photoFavArray;
@property NSString *hashtag;
@property JSONParser *parser;
@property Reachability *internetConnectionReach;
@property SavedDataAccessor *dataAccessor;

@end


@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosArray = [NSMutableArray new];
    self.dataAccessor = [SavedDataAccessor new];
    self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
    self.parser = [JSONParser new];

    //Default search is by hashtag:"cats". ^_^
    self.hashtag = @"cats";
    self.searchBar.text = self.hashtag;
    self.parser.delegate = self;
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    if ([self.internetConnectionReach isReachable])
    {
        [self.parser getImagesFromHashtagSearch:self.hashtag];
        [self.spinner startAnimating];
    }
    else
    {
#warning ****** display something like: "Internet Connection Unavailable" in the View Controller (maybe an AlertView?) ******
        NSLog(@"Internet Unavailable.");
        [self.spinner stopAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photoFavArray = [self.dataAccessor retrieveArrayFromFile];
    [self comparePhotoArray:self.photosArray withFavArray:self.photoFavArray];
    [self.collectionView reloadData];
}

//-----------------------------    Search Bar Delegate Method    -----------------------------------
#pragma mark - Search Bar Delegate Method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    NSArray* words = [searchTerm componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* searchTermWithoutWhitespace = [words componentsJoinedByString:@""];

    //only do a search if searchTerm does not consist of only whitespace
    if (searchTermWithoutWhitespace != 0)
    {
        [self.spinner startAnimating];
        if (self.segmentedControl.selectedSegmentIndex == 0)
        {
            [self.parser getImagesFromHashtagSearch:searchTermWithoutWhitespace];

        }
        else
        {
            [self.parser getImagesFromUserNameSearch:searchTermWithoutWhitespace];
        }
        searchBar.text = searchTermWithoutWhitespace;
        [searchBar resignFirstResponder];
    }
}

- (IBAction)onSegmentSwitch:(id)sender
{
    self.searchBar.text = @"";
}



//-------------------------------    JSON Parser Delegate Methods    -----------------------------------
#pragma mark - JSON Parser
- (void)didFinishJSONSearchWithMutableArray:(NSMutableArray *)mutableArray
{
    [self.spinner stopAnimating];
    self.photosArray = mutableArray;
    [self comparePhotoArray:self.photosArray withFavArray:self.photoFavArray];
    [self.collectionView reloadData];
}

- (void)lostNetworkConnection
{
    [self.spinner stopAnimating];
    //Display "Lost Network Connection. Try again" or something.
    NSLog(@"Lost Network Connection");
}

//----------------------------------    Collection View Methods   -----------------------------------
#pragma mark - Collection View Methods
- (CustomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

    Photo *photo = self.photosArray[indexPath.item];
    cell.imageView.image = photo.image;
    cell.imageIsFavView.image = [photo getIndicatorImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.photosArray objectAtIndex:indexPath.row];
    //retrieves array from plish and adds/removes the photo depending on if it's favorited or not
    self.photoFavArray = [self addOrRemove:photo fromFavArray:[self.dataAccessor retrieveArrayFromFile]];
    [self.collectionView reloadData];
    [self.dataAccessor saveArrayToFile:self.photoFavArray];
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


//----------------------------------    Comparison Helper Methods   -----------------------------------
#pragma mark - Comparison Helper Methods
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

- (void)comparePhotoArray: (NSMutableArray *)photoArray withFavArray: (NSMutableArray *)favArray
{
    for (Photo *photo in photoArray)
    {
        photo.isFavorite = NO;
        for (Photo *favPhoto in favArray)
        {
            if ([favPhoto.uniqueID isEqualToString:photo.uniqueID])
            {
                photo.isFavorite = YES;
                break;
            }
        }
    }
}

@end
