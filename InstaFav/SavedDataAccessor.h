//
//  SavedDataAccessor.h
//  InstaFav
//
//  Created by Yi-Chin Sun on 1/24/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SavedDataAccessor : NSObject

- (void)saveArrayToFile: (NSMutableArray *) dataArray;
- (NSMutableArray *)retrieveArrayFromFile;

@end
