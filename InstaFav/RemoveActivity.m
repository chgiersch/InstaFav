//
//  Unfavorite.m
//  InstaFav
//
//  Created by Yi-Chin Sun on 1/25/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "RemoveActivity.h"

@implementation RemoveActivity

- (NSString *)activityType
{
    return @"InstaFav.Unfavorite";
}

- (NSString *)activityTitle
{
    return @"RemoveActivity";
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [UIImage imageNamed:@"iPadShare.png"];
    }
    else
    {
        return [UIImage imageNamed:@"iPhoneShare.png"];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    self.activityItems = activityItems;
}

- (UIViewController *)activityViewController
{
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity

    [self.delegate didPressRemoveButton:self.activityItems];
}

@end
