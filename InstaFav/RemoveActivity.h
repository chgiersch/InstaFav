//
//  Unfavorite.h
//  InstaFav
//
//  Created by Yi-Chin Sun on 1/25/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemoveDelegate <NSObject>

- (void)didPressRemoveButton: (NSArray *)activityItems;

@end

@interface RemoveActivity : UIActivity

@property (nonatomic, weak) id<RemoveDelegate> delegate;
@property NSArray *activityItems;

@end
