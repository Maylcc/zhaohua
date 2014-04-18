//
//  NetConnect.m
//  ArtSearching
//
//  Created by developer on 14-4-17.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "NetConnect.h"
@interface NetConnect()
{
    BOOL isStringElement;
    NSMutableString *stringForArtList;
}
@end
@implementation NetConnect
static NetConnect *netConnect;
+ (NetConnect *)sharedSelf
{
    @synchronized(self)
    {
        if(netConnect == nil)
        {
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

-(void)obtainStartList
{
    NSString *hostUrl = [NSString stringWithFormat:@"%@%@",hostForXM,startList];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostUrl]];
    AFHTTPRequestOperation *operate = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operate setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSData *returnData = [operation responseData];
        NSXMLParser *parserData = [[NSXMLParser alloc] initWithData:returnData];
        parserData.delegate = self;
        [parserData parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"fail string is %@",operation.responseString);
    }];
    [operate start];
}

- (void)obTainDataForCoreData:(NSString *)stringData
{
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
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"string"])
    {
        isStringElement = NO;
        // NSLog(@"string is %@",stringForArtList);
        [self obTainDataForCoreData:stringForArtList];
    }
}

//报告解析的结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (NSDictionary *)stringToJSONData:(NSString *)jsonData
{
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableLeaves error:nil];
    return dicData;
}
@end
