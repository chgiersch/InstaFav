//
//  FavoritesViewController.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "FavoritesViewController.h"

#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "Photo.h"
#import "CustomCollectionViewCell.h"
#import "SavedDataAccessor.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate>

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

#warning ****** Figure out when/where to put this method. Will the tweet button be on the customCollectionViewCell or the view controller? ******
- (void)tweetFavImage: (Photo *)photo
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Tweeting from InstaFav app! :)"];
        [tweetSheet addImage:photo.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#warning ****** Figure out when/where to put this method. Will the e-mail button be on the customCollectionViewCell or the view controller? ******
- (void)emailFavImage: (Photo *)photo
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"InstaFav"];
        [mail setMessageBody:@"Look at this picture I InstaFaved!" isHTML:NO];
        [mail setToRecipients:@[@"testingEmail@example.com"]];
        NSData *myData = UIImagePNGRepresentation(photo.image);
        [mail addAttachmentData:myData mimeType:@"image/png" fileName:@"InstaFavImage"];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
