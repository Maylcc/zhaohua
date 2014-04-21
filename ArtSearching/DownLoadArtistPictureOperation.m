//
//  DownLoadArtistPictureOperation.m
//  ArtSearching
//
//  Created by developer on 14-4-21.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "DownLoadArtistPictureOperation.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "StartArtistsList.h"
#import "StartGalleryList.h"
#import "ZXYProvider.h"
#import "LCYCommon.h"
#import "ZXYFileOperation.h"
@interface DownLoadArtistPictureOperation()
{
    NSString *_thisUrl;
    NSString *_DBName;
    ZXYProvider *dataProvider;
    ZXYFileOperation *fileManager;
    NSString *_stringID;;
}
@property (nonatomic,strong)NSString *thisUrl;
@property (nonatomic,strong)NSString *DBName;
@end

@implementation DownLoadArtistPictureOperation
@synthesize thisUrl = _thisUrl;
@synthesize DBName  = _DBName;
-(id)initWithUrl:(NSString *)urlString byType:(NSString *)DBName andID:(NSString *)stringID
{
    if(self = [super init])
    {
        self.thisUrl = urlString;
        self.DBName  = DBName;
        dataProvider = [ZXYProvider sharedInstance];
        fileManager = [ZXYFileOperation sharedSelf];
        _stringID = stringID;
    }
    return self;
}

- (void)main
{
   if(_stringID && self.thisUrl)
    {
        NSString *stringURL = [NSString stringWithFormat:@"%@%@",imageHost,self.thisUrl];
        NSLog(@"string URL is ___________________?>>>>>>> %@",stringURL);
        NSString *urlString = [[NSString stringWithFormat:@"%@%@",imageHost,self.thisUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        AFHTTPRequestOperation *operation  = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIImage *downImg = (UIImage *)responseObject;
            NSData *imageData = UIImageJPEGRepresentation(downImg, 0.9
                                                          );
            [imageData writeToFile:[fileManager findArtistOfStartByUrl:self.thisUrl andID:_stringID withType:@""]atomically:YES];
            
//            NSNotification *noti = [NSNotification notificationWithName:@"DataListViewFresh" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:noti];
            NSLog(@"success");

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"下载图片失败 error is %@",error);
        }];
        [operation start];
    }
}
@end
