//
//  JSONParser.h
//  GetOnThatBus
//
//  Created by Yi-Chin Sun on 1/20/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@protocol ParserDelegate <NSObject>

- (void)didFinishJSONSearchWithMutableArray:(NSMutableArray *)mutableArray;
- (void)lostNetworkConnection;

@end

@interface JSONParser : NSObject

@property (nonatomic, weak) id<ParserDelegate> delegate;

- (void)getImagesFromHashtagSearch:(NSString *)hashtag;
- (void)getImagesFromUserNameSearch:(NSString *)userName;


@end

