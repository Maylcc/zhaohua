//
//  ZXYFileOperation.m
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ZXYFileOperation.h"
#import "ZXYProvider.h"
#import "StartArtistsList.h"
#import "StartArtList.h"
#import "StartGalleryList.h"
@implementation ZXYFileOperation
static ZXYFileOperation *fileOperation;
+(ZXYFileOperation *)sharedSelf
{
    @synchronized(self)
    {
        if(fileOperation == nil)
        {
            return [[self alloc] init];
        }
    }
    return fileOperation;
}

+(id)alloc
{
    @synchronized(self)
    {
        fileOperation = [super alloc];
        return fileOperation;
    }
    return nil;
}

-(NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)cathePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)tempPath
{
    NSString *path = NSTemporaryDirectory();
    return path;
}

-(BOOL)createFileAtPath:(NSString *)filePath isDirectory:(BOOL)isDirectory withData:(NSData *)fileData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        NSLog(@"文件夹已经存在");
        return YES;
    }
    else
    {
        if([fileManager createFileAtPath:filePath contents:fileData attributes:nil])
        {
            return YES;
        }
        else
        {
            NSLog(@"error in createFileAtPath");
            return NO;
        }
        
    }
}

-(BOOL)createDirectoryAtPath:(NSString *)direcPath withBool:(BOOL)withB
{
    if([self fileExistsAtPath:direcPath isDirectory:&withB])
    {
        NSLog(@"direct have exist");
        return YES;
    }
    else
    {
        if([self createDirectoryAtPath:direcPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (NSString *)findArtOfStartByID:(NSNumber *)art_id
{
    ZXYProvider *provider = [ZXYProvider sharedInstance];
    NSArray *artList = [provider readCoreDataFromDB:@"StartArtList" withContent:[NSString stringWithFormat:@"%d",art_id.intValue] andKey:@"id_Art"];
    StartArtList *startArt;
    NSString *pathString;
    if(artList.count)
    {
        startArt = [artList objectAtIndex:0];
        NSNumber *id_art = startArt.id_Art;
        NSString *lastComponent = [startArt.url_Small componentsSeparatedByString:@"/"].lastObject;
        NSString *contentDire = [[self tempPath] stringByAppendingPathComponent:@"startArt"];
        [self createDirectoryAtPath:contentDire withBool:YES];
        pathString = [contentDire stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",id_art.intValue,lastComponent]];
    }
    return pathString;
}

- (NSString *)findArtOfStartByUrl:(NSString *)url
{
    ZXYProvider *provider = [ZXYProvider sharedInstance];
    NSArray *artList = [provider readCoreDataFromDB:@"StartArtList" withContent:[NSString stringWithFormat:@"%@",url] andKey:@"url_Small"];
    StartArtList *startArt;
    NSString *pathString;
    if(artList.count)
    {
        startArt = [artList objectAtIndex:0];
        NSNumber *id_art = startArt.id_Art;
        NSString *lastComponent = [startArt.url_Small componentsSeparatedByString:@"/"].lastObject;
        NSString *contentDire = [[self tempPath] stringByAppendingPathComponent:@"startArt"];
        [self createDirectoryAtPath:contentDire withBool:YES];
        pathString = [contentDire stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",id_art.intValue,lastComponent]];
    }
    return pathString;
}

- (NSString *)findArtOfStartByUrlBig:(NSString *)url
{
    ZXYProvider *provider = [ZXYProvider sharedInstance];
    NSArray *artList = [provider readCoreDataFromDB:@"StartArtList" withContent:[NSString stringWithFormat:@"%@",url] andKey:@"url"];
    StartArtList *startArt;
    NSString *pathString;
    if(artList.count)
    {
        startArt = [artList objectAtIndex:0];
        NSNumber *id_art = startArt.id_Art;
        NSString *lastComponent = [startArt.url componentsSeparatedByString:@"/"].lastObject;
        NSString *contentDire = [[self tempPath] stringByAppendingPathComponent:@"startArt"];
        [self createDirectoryAtPath:contentDire withBool:YES];
        pathString = [contentDire stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",id_art.intValue,lastComponent]];
    }
    return pathString;
}

- (NSString *)findArtistOfStartByUrl:(NSString *)url andID:(NSString *)userid withType:(NSString *)type
{
    NSString *pathString;
    
    NSNumber *id_art = [NSNumber numberWithInt:userid.intValue];
    NSString *lastComponent = [url componentsSeparatedByString:@"/"].lastObject;
    NSString *contentDire = [[self tempPath] stringByAppendingPathComponent:@"startArtist"];
    [self createDirectoryAtPath:contentDire withBool:YES];
    pathString = [contentDire stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",id_art.intValue,lastComponent]];
    return pathString;
}

@end
