//
//  Photo.m
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.uniqueID = dictionary[@"id"];
        self.isFavorite = NO;

        NSURL *imageURL = [NSURL URLWithString:dictionary[@"images"][@"standard_resolution"][@"url"]];

        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        self.image = image;

        NSDictionary *location = dictionary[@"location"];
        if (![location isKindOfClass:[NSNull class]])
        {
            double latitude = [location[@"latitude"] doubleValue];
            double longitude = [location[@"longitude" ] doubleValue];
            self.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
        }
        self.hashtags = dictionary[@"tags"];
        self.userName = dictionary[@"user"][@"username"];
    }
    return self;
}

@end
