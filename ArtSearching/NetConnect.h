//
//  NetConnect.h
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LCYCommon.h"
@interface NetConnect : NSObject
+(NetConnect *)sharedSelf;

-(void)obtainStartList;
@end
