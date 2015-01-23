//
//  JSONParser.m
//  GetOnThatBus
//
//  Created by Yi-Chin Sun on 1/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

-(void)getImagesFromHashtagSearch:(NSString *)hashtag
{
    NSMutableArray * photosArray = [NSMutableArray new];
    NSURL * url;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=1080703211.c72c489.2beaba2c15ed41b58a2df695a4bf1d56", hashtag]];

    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *instagramData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *instagramPostArray = instagramData[@"data"];
        for (NSDictionary *post in instagramPostArray)
        {
            Photo *newPhoto = [Photo new];

            NSDictionary *images = post[@"images"];
            newPhoto.uniqueID = post[@"id"];
            newPhoto.isFavorite = NO;

            NSURL *imageURL = images[@"standard_resolution"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
            newPhoto.image = image;

            NSDictionary *location = post[@"location"];
            if (location)
            {
                double latitude = [location[@"latitude"] doubleValue];
                double longitude = [location[@"longitude" ] doubleValue];
                newPhoto.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
            }

            newPhoto.hashtags = post[@"tags"];
            newPhoto.userName = post[@"user"][@"username"];

            [photosArray addObject:newPhoto];
        }
        //DELEGATE

    }];
}

@end
