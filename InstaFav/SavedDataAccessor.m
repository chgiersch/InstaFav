//
//  SavedDataAccessor.m
//  InstaFav
//
//  Created by Yi-Chin Sun on 1/24/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "SavedDataAccessor.h"
#define kDateKey @"dateSaved"

@implementation SavedDataAccessor

- (NSURL *)documentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

- (NSURL *)plist
{
    NSURL *plistPath = [[self documentsDirectory] URLByAppendingPathComponent:@"Photos.plist"];
    return plistPath;
}

- (void)saveArrayToFile: (NSMutableArray *) dataArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataArray];
    [data writeToURL:[self plist] atomically:YES];  // This is saving a custom Photo class subclassing NSObject
    [defaults setObject:[NSDate date] forKey:kDateKey];
    [defaults synchronize];
}

- (NSMutableArray *)retrieveArrayFromFile
{
    NSData *data = [NSData dataWithContentsOfURL:[self plist]];
    
    if (![NSData dataWithContentsOfURL:[self plist]])
    {
        return [NSMutableArray new];
    }
    else
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

@end
