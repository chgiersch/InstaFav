//
//  Photo.h
//  InstaFav
//
//  Created by Chris Giersch on 1/22/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property NSString *uniqueID;
@property BOOL isFavorite;
@property UIImage *image;
//@property CLLocation *location;
@property NSMutableArray *hashtags;
@property NSString *userName;

@end
