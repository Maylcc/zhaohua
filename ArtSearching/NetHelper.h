//
//  NetHelper.h
//  ArtSearching
//
//  Created by developer on 14-5-12.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "NetHelperDelegate.h"
@interface NetHelper : NSObject
@property (nonatomic,strong)id<NetHelperDelegate>netHelperDelegate;
+(NetHelper *)sharedSelf;
- (void)requestStart:(NSString *)urlString withParams:(NSDictionary *)params bySerialize:(AFHTTPResponseSerializer *)serializer;
@end
