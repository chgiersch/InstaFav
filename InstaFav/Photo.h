//
//  Photo.h
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface Photo : NSObject <NSCoding>

- (void)encodeWithCoder:(NSCoder *)encoder;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithCoder:(NSCoder *)decoder;
- (UIImage *)getIndicatorImage;

@property NSString *uniqueID;
@property BOOL isFavorite;
@property UIImage *image;
@property CLLocationCoordinate2D coordinate;
@property NSArray *hashtags;
@property NSString *userName;

@end
