//
//  DownLoadPictureOperation.m
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DownLoadPictureOperation.h"
#import "LCYCommon.h"
#import <AFNetworking/AFNetworking.h>
#import "StartArtList.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface DownLoadPictureOperation()
{
    NSMutableArray *_pictureURLS;
    StartArtList *_startArt;
    BOOL isAllDown;
    ZXYFileOperation *fileManager;
    NSInteger indexOfCurrentDown;
    BOOL isDown;
}
@property(atomic,strong)NSMutableArray *pictureURLS;
@property(atomic,strong)StartArtList *startArt;
@end
@implementation DownLoadPictureOperation
@synthesize pictureURLS = _pictureURLS;
@synthesize startArt    = _startArt;
-(id)initWithPicUrls:(NSArray *)urlArr
{
    if(self=[super init])
    {
        fileManager = [ZXYFileOperation sharedSelf];
        indexOfCurrentDown = 0;
        isDown = NO;
        self.pictureURLS = [NSMutableArray arrayWithArray:urlArr];
    }
    return self;
}

-(id)initWithUrl:(StartArtList *)startArt
{
    if(self=[super init])
    {
        fileManager = [ZXYFileOperation sharedSelf];
//        indexOfCurrentDown = 0;
//        isDown = NO;
        self.startArt = startArt;
        isDown = NO;
    }
    return self;
}

-(void)main
{

    StartArtList *startArt = self.startArt;//[self.pictureURLS
    NSString *urlStrings = [[imageHost stringByAppendingString:startArt.url_Small] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    NSURL *url = [NSURL URLWithString:urlStrings];
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    request.responseSerializer = [AFImageResponseSerializer serializer];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage *downImg = (UIImage *)responseObject;
        NSData *imageData = UIImageJPEGRepresentation(downImg, 0.9);
        [imageData writeToFile:[fileManager findArtOfStartByID:startArt.id_Art] atomically:YES];
        isDown = YES;
        NSNotification *noti = [NSNotification notificationWithName:@"DataListViewFresh" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        NSLog(@"success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isDown = YES;
        NSLog(@"error is %@",error);
    }];
    indexOfCurrentDown ++;
    [request start];
}
@end
