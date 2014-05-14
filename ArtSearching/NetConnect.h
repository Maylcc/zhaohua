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
#import "ZXYProvider.h"
#import "ZXYFileOperation.h"
@interface NetConnect : NSObject<NSXMLParserDelegate>
{
    ZXYProvider *dataProvider;
    ZXYFileOperation *fileManager;
}
+(NetConnect *)sharedSelf;
/*
 从服务器获取明星作品以及明星画廊
 */
-(void)obtainStartList;
/*
 从服务器获取星级作品的详细页面的内容
 */
-(void)obtainStartArtDetailInfo:(NSString *)workID;


@end
