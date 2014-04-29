//
//  LCYXDTools.h
//  ArtSearching
//
//  Created by Licy on 14-4-29.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface LCYXDTools : NSObject
+ (ASIFormDataRequest*)postRequestWithDict:(NSString *)body API:(NSString *)api;
+ (NSDictionary *)JSonFromString:(NSString* )result;
@end
