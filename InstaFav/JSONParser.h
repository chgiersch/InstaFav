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
@end

@interface JSONParser : NSObject

-(void)getImagesFromHashtagSearch:(NSString *)hashtag;

@property (nonatomic, weak) id<ParserDelegate> delegate;

@end

