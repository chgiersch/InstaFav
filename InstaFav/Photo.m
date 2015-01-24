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

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.uniqueID forKey:@"uniqueID"];
    [encoder encodeBool:self.isFavorite forKey:@"isFavorite"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeDouble:self.coordinate.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.coordinate.longitude forKey:@"longitide"];
    [encoder encodeObject:self.hashtags forKey:@"hashtags"];
    [encoder encodeObject:self.userName forKey:@"userName"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.uniqueID = [decoder decodeObjectForKey:@"uniqueID"];
        self.isFavorite = [decoder decodeBoolForKey:@"isFavorite"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.coordinate = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:@"latitude"], [decoder decodeDoubleForKey:@"longitude"]);
        self.hashtags = [decoder decodeObjectForKey:@"hashtags"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
    }
    return self;
}

-(UIImage *)getIndicatorImage
{
    if (self.isFavorite)
    {
        return [UIImage imageNamed:@"favheart"];
    }
    else
    {
        return [UIImage imageNamed:@"heart"];
    }
}

@end
