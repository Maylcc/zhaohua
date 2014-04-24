//
//  ZXYFileOperation.h
//  ArtSearching
//
//  Created by developer on 14-4-20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXYFileOperation : NSFileManager
/*
    实例化方法
 */
+(ZXYFileOperation *)sharedSelf;
/*
    获得沙河常用到德三个文件夹的目录
 */
-(NSString *)documentsPath;
-(NSString *)tempPath;
-(NSString *)cathePath;

/*
    创建文件以及文件夹
 */
-(BOOL)createFileAtPath:(NSString *)filePath isDirectory:(BOOL)isDirectory withData:(NSData *)fileData;
-(BOOL)createDirectoryAtPath:(NSString *)direcPath withBool:(BOOL)withB;

/*
   获得星级作品图片的地址传入id
 */
- (NSString *)findArtOfStartByID:(NSNumber *)art_id;

/*
 获取星级作品图片的地址 传入url
 */

- (NSString *)findArtOfStartByUrl:(NSString *)url;

/*
 获得星级作者图片的地址 传入url
 */
- (NSString *)findArtistOfStartByUrl:(NSString *)url andID:(NSString *)userid withType:(NSString *)type;

/*
 获得大图片  传入url
 */
- (NSString *)findArtOfStartByUrlBig:(NSString *)url;
@end
