//
//  NetConnect.m
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "NetConnect.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "DownLoadPictureOperation.h"
#import "DownLoadArtistPictureOperation.h"
@interface NetConnect()
{
    BOOL isStringElement;
    BOOL isStringElementForDetailWork;
    NSMutableString *stringForArtList;
    NSString *workID;
}
@end
@implementation NetConnect
static NetConnect *netConnect;
static NSOperationQueue *queue;
+ (NetConnect *)sharedSelf
{
    @synchronized(self)
    {
        if(netConnect == nil)
        {
            queue = [[NSOperationQueue alloc] init];
            [queue setMaxConcurrentOperationCount:1];
            return [[self alloc] init];
        }
    }
    return netConnect;
}

+ (id)alloc
{
    @synchronized(self)
    {
            netConnect = [super alloc];
            return netConnect;
    }
    return nil;
}
#pragma mark - 判断网络是否连接
//- (BOOL)isNetConnect
//{
//    
//}

#pragma  mark - 获取明星数据
/**
 获取所有的明星数据
 */
-(void)obtainStartList
{
    NSString *hostUrl = [NSString stringWithFormat:@"%@%@",hostForXM,startList];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostUrl]];
    AFHTTPRequestOperation *operate = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operate setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSData *returnData = [operation responseData];
        // !!!:此处解析获得的明星数据
        NSXMLParser *parserData = [[NSXMLParser alloc] initWithData:returnData];
        parserData.delegate = self;
        [parserData parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"fail string is %@",operation.responseString);
    }];
    [operate start];
}

/**
 将获得的明星数据保存到数据库
 */
// !!!:此处将明星数据保存到数据库中
- (void)obTainDataForCoreData:(NSString *)stringData
{
    fileManager = [ZXYFileOperation sharedSelf];
    dataProvider = [ZXYProvider sharedInstance];
    NSDictionary *dicData          = [self stringToJSONData:stringData];
    NSDictionary *startArtistsList = [self stringToJSONData:[dicData objectForKey:@"StarArtistsList"] ];
    NSDictionary *startWorkList    = [self stringToJSONData:[dicData objectForKey:@"StarArtorkList"] ];
    NSDictionary *startGallerList  = [self stringToJSONData:[dicData objectForKey:@"StarGalleryList"] ];
    NSArray      *artistsList      = [startArtistsList objectForKey:@"starArtsList"];
    
    NSArray      *workList         = [startWorkList objectForKey:@"starWorkList"];
   
    NSArray      *gallerList       = [startGallerList objectForKey:@"starGalleryList"];
    [dataProvider saveStartArtistsList:artistsList];
    [dataProvider saveStartArtList:workList];
    [dataProvider saveStartGalleryList:gallerList];
    NSNotification *noti = [NSNotification notificationWithName:@"DataListViewFresh" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    NSArray *allStartArt = [dataProvider readCoreDataFromDB:@"StartArtList" orderByKey:@"beScanTime" isDes:NO];
    NSArray *allStartArtist = [dataProvider readCoreDataFromDB:@"StartArtistsList" orderByKey:@"beScanTime" isDes:NO];
    NSArray *allStartGallery = [dataProvider readCoreDataFromDB:@"StartGalleryList" orderByKey:@"beScanTime" isDes:NO];
    // !!!:此处下载星级作品的图片（小图片）
    for(int i = 0;i<allStartArt.count;i++)
    {
        NSString *filePaths = [fileManager findArtOfStartByUrl:[[allStartArt objectAtIndex:i] valueForKeyPath:@"url_Small"]];
        if([fileManager fileExistsAtPath:filePaths])
        {
            continue;
        }
        DownLoadPictureOperation *downPicOperation = [[DownLoadPictureOperation alloc] initWithUrl:allStartArt[i]];
        [queue addOperation:downPicOperation];
    }
    // !!!:此处下载星级作者的图片
    for(int i = 0;i<allStartArtist.count;i++)
    {
        NSString *filePaths = [fileManager findArtistOfStartByUrl:[[allStartArtist objectAtIndex:i]valueForKey:@"url_small"]andID:[[allStartArtist objectAtIndex:i]valueForKey:@"id_Art"] withType:@""];
        if([fileManager fileExistsAtPath:filePaths])
        {
            continue;
        }
        DownLoadArtistPictureOperation *downOperation = [[DownLoadArtistPictureOperation alloc] initWithUrl:[[allStartArtist objectAtIndex:i]valueForKey:@"url_small"] byType:@"StartArtistsList" andID:[[allStartArtist objectAtIndex:i] valueForKeyPath:@"id_Art"]];
        [queue addOperation:downOperation];
    }
    // !!!:此处下载星级画廊的图片
    for(int i = 0;i<allStartGallery.count;i++)
    {
        NSString *filePaths = [fileManager findArtistOfStartByUrl:[[allStartGallery objectAtIndex:i]valueForKey:@"url"]andID:[[allStartGallery objectAtIndex:i]valueForKey:@"id_Art"] withType:@""];
        if([fileManager fileExistsAtPath:filePaths])
        {
            continue;
        }
        DownLoadArtistPictureOperation *downOperation = [[DownLoadArtistPictureOperation alloc] initWithUrl:[[allStartGallery objectAtIndex:i]valueForKey:@"url"] byType:@"StartGalleryList" andID:[[allStartGallery objectAtIndex:i] valueForKey:@"id_Art"]];
        [queue addOperation:downOperation];
    }
    while (YES) {
       
            if(queue.operations.count == 0)
            {
                NSNotification *notis = [NSNotification notificationWithName:@"DataListViewFresh" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notis];
                break;
            }
        
    }
}

/**
 获取星级作品的详细信息
 */
// !!!:此处获取星级作品的详细信息
- (void)obtainStartArtDetailInfo:(NSString *)workIDs
{
    workID = workIDs;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostForXM,startArtDetail];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:workID forKey:@"workID"];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功了啊-------------------------------------,%@",[operation responseString]);
        isStringElementForDetailWork = YES;
        // !!!:此处解析获取的星级作品
        NSXMLParser *parserData = [[NSXMLParser alloc] initWithData:[operation responseData]];
        parserData.delegate = self;
        [parserData parse];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
    
}

- (void)dataForProviderOfDetailWork:(NSString *)dataString
{
    fileManager = [ZXYFileOperation sharedSelf];
    dataProvider = [ZXYProvider sharedInstance];
    NSData *paseData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:paseData options:NSJSONReadingMutableLeaves error:nil];
    // !!!:此处将星级作品的详细信息保存到数据库中
    [dataProvider saveArtDetailToCoreData:dic withID:workID];
    NSNotification *noti = [NSNotification notificationWithName:@"artDetailNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    NSLog(@"artistID is %@",[dic objectForKey:@"artistId"]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"string"])
    {
        stringForArtList = [[NSMutableString alloc] init];
        isStringElement = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(isStringElement)
    {
        [stringForArtList appendString:string];
    }
}

//发现元素结束符的处理函数，保存元素各项目数据（即报告元素的结束标记）
#pragma mark - 解析完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"string"])
    {
        isStringElement = NO;
        // NSLog(@"string is %@",stringForArtList);
        if(isStringElementForDetailWork)
        {
            isStringElementForDetailWork = NO;
            [self dataForProviderOfDetailWork:stringForArtList];
        }
        else
        {
            [self obTainDataForCoreData:stringForArtList];
        }
    }
}

//报告解析的结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (NSDictionary *)stringToJSONData:(NSString *)jsonData
{
    if([jsonData isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableLeaves error:nil];
    return dicData;
}
@end
